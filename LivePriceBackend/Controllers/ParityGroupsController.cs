using LivePriceBackend.Constants;
using LivePriceBackend.Data;
using LivePriceBackend.DTOs.ParityGroup;
using LivePriceBackend.Extensions.EntityExtenders;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LivePriceBackend.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class ParityGroupsController(LivePriceDbContext context) : ControllerBase
{
    [HttpGet]
    public async Task<IActionResult> GetParityGroups()
    {
        var data = await context.ParityGroups
            .AsNoTracking()
            .Select(pg => pg.ToViewModel())
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetParityGroup(int id)
    {
        var data = await context.ParityGroups
            .AsNoTracking()
            .FirstOrDefaultAsync(pg => pg.Id == id);

        if (data == null)
            return NotFound(ErrorMessages.ParityGroupNotFound);

        return Ok(data.ToViewModel());
    }

    [HttpPost]
    public async Task<IActionResult> CreateParityGroup(ParityGroupCreateModel model)
    {
        if (await context.ParityGroups.AnyAsync(pg => pg.Name == model.Name))
            return BadRequest(ErrorMessages.ParityGroupExists);

        var entity = model.ToEntity();

        await context.ParityGroups.AddAsync(entity);
        await context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetParityGroup), new { id = entity.Id }, entity);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> UpdateParityGroup(int id, ParityGroupUpdateModel model)
    {
        var entity = await context.ParityGroups
            .FirstOrDefaultAsync(pg => pg.Id == id);

        if (entity == null)
            return NotFound(ErrorMessages.ParityGroupNotFound);

        model.UpdateEntity(entity);

        await context.SaveChangesAsync();

        return Ok(entity);
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> DeleteParityGroup(int id)
    {
        var entity = await context.ParityGroups
            .FirstOrDefaultAsync(pg => pg.Id == id);

        if (entity == null)
            return NotFound(ErrorMessages.ParityGroupNotFound);

        context.ParityGroups.Remove(entity);
        await context.SaveChangesAsync();

        return Ok();
    }
}