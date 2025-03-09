using LivePriceBackend.Constants;
using LivePriceBackend.Data;
using LivePriceBackend.DTOs.ParityGroup;
using LivePriceBackend.Extensions;
using LivePriceBackend.Extensions.EntityExtenders;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Swashbuckle.AspNetCore.Annotations;

namespace LivePriceBackend.Controllers.Common;

[ApiController]
[Route("api/[controller]")]
public class ParityGroupsController(LivePriceDbContext context) : ControllerBase
{
    /// <summary>
    /// Get all parity groups.
    /// </summary>
    /// <returns>List of ParityGroupViewModel</returns>
    [Authorize(Roles = "Admin,Customer")]
    [HttpGet]
    [SwaggerOperation(Summary = "Retrieves all parity groups", Description = "Returns a list of all parity groups in the system.")]
    [SwaggerResponse(StatusCodes.Status200OK, "List of parity groups retrieved successfully", typeof(IEnumerable<ParityGroupViewModel>))]
    public async Task<IActionResult> GetParityGroups()
    {

        if (User.GetCustomerId() != null)
        {
            var cParityGroups = await context.ParityGroups
                .AsNoTracking()
                .Where(pg => pg.IsEnabled)
                .ToListAsync();
            
            var cParityGroupRules = await context.CParityGroupRules
                .AsNoTracking()
                .Where(r => r.CustomerId == User.GetCustomerId())
                .ToListAsync();
            
            var cParityGroupViewModels = cParityGroups.Select(pg =>
            {
                var rule = cParityGroupRules.FirstOrDefault(r => r.ParityGroupId == pg.Id);
                return pg.ToCustomerViewModel(rule ?? null);
            });

            return Ok(cParityGroupViewModels);
        }

        var parityGroups = await context.ParityGroups
            .AsNoTracking()
            .Select(pg => pg.ToViewModel())
            .ToListAsync();

        return Ok(parityGroups);
    }

    /// <summary>
    /// Get a parity group by ID.
    /// </summary>
    /// <param name="id">Parity Group ID</param>
    /// <returns>ParityGroupViewModel</returns>
    [Authorize(Roles = "Admin")]
    [HttpGet("{id:int}")]
    [SwaggerOperation(Summary = "Retrieves a parity group by ID", Description = "Returns a parity group based on the provided ID.")]
    [SwaggerResponse(StatusCodes.Status200OK, "Parity group retrieved successfully", typeof(ParityGroupViewModel))]
    [SwaggerResponse(StatusCodes.Status404NotFound, "Parity group not found")]
    public async Task<IActionResult> GetParityGroup(int id)
    {
        var data = await context.ParityGroups
            .AsNoTracking()
            .FirstOrDefaultAsync(pg => pg.Id == id);

        if (data == null)
            return NotFound(new { message = ErrorMessages.ParityGroupNotFound });

        return Ok(data.ToViewModel());
    }

    /// <summary>
    /// Create a new parity group.
    /// </summary>
    /// <param name="model">ParityGroupCreateModel</param>
    /// <returns>Created ParityGroupViewModel</returns>
    [Authorize(Roles = "Admin")]
    [HttpPost]
    [SwaggerOperation(Summary = "Creates a new parity group", Description = "Creates a new parity group with the provided details.")]
    [SwaggerResponse(StatusCodes.Status201Created, "Parity group created successfully", typeof(ParityGroupViewModel))]
    [SwaggerResponse(StatusCodes.Status400BadRequest, "Parity group already exists")]
    public async Task<IActionResult> CreateParityGroup(ParityGroupCreateModel model)
    {
        if (await context.ParityGroups.AnyAsync(pg => pg.Name == model.Name))
            return BadRequest(new { message = ErrorMessages.ParityGroupExists });

        var entity = model.ToEntity();

        await context.ParityGroups.AddAsync(entity);
        await context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetParityGroup), new { id = entity.Id }, entity.ToViewModel());
    }

    /// <summary>
    /// Update an existing parity group.
    /// </summary>
    /// <param name="id">Parity Group ID</param>
    /// <param name="model">ParityGroupUpdateModel</param>
    /// <returns>Updated ParityGroupViewModel</returns>
    [Authorize(Roles = "Admin")]
    [HttpPut("{id:int}")]
    [SwaggerOperation(Summary = "Updates an existing parity group",
        Description = "Updates the details of an existing parity group based on the provided ID.")]
    [SwaggerResponse(StatusCodes.Status200OK, "Parity group updated successfully", typeof(ParityGroupViewModel))]
    [SwaggerResponse(StatusCodes.Status404NotFound, "Parity group not found")]
    public async Task<IActionResult> UpdateParityGroup(int id, ParityGroupUpdateModel model)
    {
        var entity = await context.ParityGroups.FirstOrDefaultAsync(pg => pg.Id == id);

        if (entity == null)
            return NotFound(new { message = ErrorMessages.ParityGroupNotFound });

        model.UpdateEntity(entity);
        await context.SaveChangesAsync();

        return Ok(entity.ToViewModel());
    }

    /// <summary>
    /// Update the status of an existing parity group.
    /// </summary>
    /// <param name="id">Parity Group ID</param>
    /// <param name="isEnabled">New status</param>
    /// <returns>No content</returns>
    [Authorize(Roles = "Admin")]
    [HttpPatch("{id:int}/status")]
    [SwaggerOperation(Summary = "Updates the status of an existing parity group",
        Description = "Updates the status of an existing parity group based on the provided ID.")]
    [SwaggerResponse(StatusCodes.Status204NoContent, "Parity group status updated successfully")]
    [SwaggerResponse(StatusCodes.Status404NotFound, "Parity group not found")]
    public async Task<IActionResult> UpdateParityGroupStatus(int id, [FromBody] bool isEnabled)
    {
        var entity = await context.ParityGroups.FirstOrDefaultAsync(pg => pg.Id == id);

        if (entity == null)
            return NotFound(new { message = ErrorMessages.ParityGroupNotFound });

        entity.IsEnabled = isEnabled;
        await context.SaveChangesAsync();

        return NoContent();
    }

    /// <summary>
    /// Delete a parity group by ID.
    /// </summary>
    /// <param name="id">Parity Group ID</param>
    /// <returns>No content</returns>
    [Authorize(Roles = "Admin")]
    [HttpDelete("{id:int}")]
    [SwaggerOperation(Summary = "Deletes a parity group by ID", Description = "Deletes a parity group based on the provided ID.")]
    [SwaggerResponse(StatusCodes.Status204NoContent, "Parity group deleted successfully")]
    [SwaggerResponse(StatusCodes.Status404NotFound, "Parity group not found")]
    public async Task<IActionResult> DeleteParityGroup(int id)
    {
        var entity = await context.ParityGroups.FirstOrDefaultAsync(pg => pg.Id == id);

        if (entity == null)
            return NotFound(new { message = ErrorMessages.ParityGroupNotFound });

        context.ParityGroups.Remove(entity);
        await context.SaveChangesAsync();

        return NoContent();
    }
}