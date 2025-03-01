using LivePriceBackend.Constants;
using LivePriceBackend.Data;
using LivePriceBackend.DTOs.Parity;
using LivePriceBackend.Extensions.EntityExtenders;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Swashbuckle.AspNetCore.Annotations;

namespace LivePriceBackend.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class ParitiesController(LivePriceDbContext context) : ControllerBase
{
    /// <summary>
    /// Get all parities.
    /// </summary>
    /// <returns>List of ParityViewModel</returns>
    [HttpGet]
    [SwaggerOperation(Summary = "Retrieves all parities", Description = "Returns a list of all parities in the system.")]
    [SwaggerResponse(StatusCodes.Status200OK, "List of parities retrieved successfully", typeof(IEnumerable<ParityViewModel>))]
    public async Task<IActionResult> GetParities()
    {
        var data = await context.Parities
            .AsNoTracking()
            .Select(p => p.ToViewModel())
            .ToListAsync();

        return Ok(data);
    }

    /// <summary>
    /// Get a parity by ID.
    /// </summary>
    /// <param name="id">Parity ID</param>
    /// <returns>ParityViewModel</returns>
    [HttpGet("{id:int}")]
    [SwaggerOperation(Summary = "Retrieves a parity by ID", Description = "Returns a parity based on the provided ID.")]
    [SwaggerResponse(StatusCodes.Status200OK, "Parity retrieved successfully", typeof(ParityViewModel))]
    [SwaggerResponse(StatusCodes.Status404NotFound, "Parity not found")]
    public async Task<IActionResult> GetParity(int id)
    {
        var data = await context.Parities
            .AsNoTracking()
            .FirstOrDefaultAsync(p => p.Id == id);

        if (data == null)
            return NotFound(new { message = ErrorMessages.ParityNotFound });

        return Ok(data.ToViewModel());
    }

    /// <summary>
    /// Create a new parity.
    /// </summary>
    /// <param name="model">ParityCreateModel</param>
    /// <returns>Created ParityViewModel</returns>
    [HttpPost]
    [SwaggerOperation(Summary = "Creates a new parity", Description = "Creates a new parity with the provided details.")]
    [SwaggerResponse(StatusCodes.Status201Created, "Parity created successfully", typeof(ParityViewModel))]
    [SwaggerResponse(StatusCodes.Status400BadRequest, "Parity already exists or Parity group not found or Parity order index already exists")]
    public async Task<IActionResult> CreateParity(ParityCreateModel model)
    {
        if (await context.Parities.AnyAsync(p => p.Symbol == model.Symbol))
            return BadRequest(new { message = ErrorMessages.ParityExists });

        if (!await context.ParityGroups.AnyAsync(pg => pg.Id == model.ParityGroupId))
            return BadRequest(new { message = ErrorMessages.ParityGroupNotFound });

        if (await context.Parities.AnyAsync(p => p.OrderIndex == model.OrderIndex))
            return BadRequest(new { message = ErrorMessages.ParityOrderIndexExists });

        var entity = model.ToEntity();

        await context.Parities.AddAsync(entity);
        await context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetParity), new { id = entity.Id }, entity.ToViewModel());
    }

    /// <summary>
    /// Update an existing parity.
    /// </summary>
    /// <param name="id">Parity ID</param>
    /// <param name="model">ParityUpdateModel</param>
    /// <returns>Updated ParityViewModel</returns>
    [HttpPut("{id:int}")]
    [SwaggerOperation(Summary = "Updates an existing parity", Description = "Updates the details of an existing parity based on the provided ID.")]
    [SwaggerResponse(StatusCodes.Status200OK, "Parity updated successfully", typeof(ParityViewModel))]
    [SwaggerResponse(StatusCodes.Status400BadRequest, "Parity already exists or Parity group not found")]
    [SwaggerResponse(StatusCodes.Status404NotFound, "Parity not found")]
    public async Task<IActionResult> UpdateParity(int id, ParityUpdateModel model)
    {
        var entity = await context.Parities.FirstOrDefaultAsync(p => p.Id == id);

        if (entity == null)
            return NotFound(new { message = ErrorMessages.ParityNotFound });

        if (await context.Parities.AnyAsync(p => p.Symbol == model.Symbol && p.Id != id))
            return BadRequest(new { message = ErrorMessages.ParityExists });

        if (!await context.ParityGroups.AnyAsync(pg => pg.Id == model.ParityGroupId))
            return BadRequest(new { message = ErrorMessages.ParityGroupNotFound });

        model.UpdateEntity(entity);
        await context.SaveChangesAsync();

        return Ok(entity.ToViewModel());
    }

    /// <summary>
    /// Delete a parity by ID.
    /// </summary>
    /// <param name="id">Parity ID</param>
    /// <returns>No content</returns>
    [HttpDelete("{id:int}")]
    [SwaggerOperation(Summary = "Deletes a parity by ID", Description = "Deletes a parity based on the provided ID.")]
    [SwaggerResponse(StatusCodes.Status204NoContent, "Parity deleted successfully")]
    [SwaggerResponse(StatusCodes.Status404NotFound, "Parity not found")]
    public async Task<IActionResult> DeleteParity(int id)
    {
        var entity = await context.Parities.FirstOrDefaultAsync(p => p.Id == id);

        if (entity == null)
            return NotFound(new { message = ErrorMessages.ParityNotFound });

        context.Parities.Remove(entity);
        await context.SaveChangesAsync();

        return NoContent();
    }
}