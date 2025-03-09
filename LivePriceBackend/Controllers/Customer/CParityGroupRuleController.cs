using LivePriceBackend.Constants;
using LivePriceBackend.Data;
using LivePriceBackend.DTOs.CParityGroupRule;
using LivePriceBackend.Entities;
using LivePriceBackend.Extensions;
using LivePriceBackend.Extensions.EntityExtenders;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Swashbuckle.AspNetCore.Annotations;

namespace LivePriceBackend.Controllers.Customer;

[Authorize]
[ApiController]
[Route("api/customer/parity-group-rules")]
public class CParityGroupRuleController(LivePriceDbContext context) : ControllerBase
{
    /// <summary>
    /// Get all parity group rules for a customer.
    /// </summary>
    /// <param name="customerId">Customer ID</param>
    /// <returns>List of CParityGroupRuleViewModel</returns>
    [HttpGet("by-customer/{customerId:int}")]
    [SwaggerOperation(Summary = "Retrieves all parity group rules for a customer",
        Description = "Returns a list of all parity group rules for the specified customer.")]
    [SwaggerResponse(StatusCodes.Status200OK, "List of parity group rules retrieved successfully",
        typeof(IEnumerable<CParityGroupRuleViewModel>))]
    [SwaggerResponse(StatusCodes.Status404NotFound, "Customer not found")]
    [SwaggerResponse(StatusCodes.Status403Forbidden, "User is not authorized to access this customer's data")]
    public async Task<IActionResult> GetByCustomerId(int customerId)
    {
        // Yetkilendirme kontrolü
        var userCustomerId = User.GetCustomerId();
        if (userCustomerId != customerId)
            return Forbid();

        // Müşteri kontrolü
        if (!await context.Customers.AnyAsync(c => c.Id == customerId))
            return NotFound(new { message = ErrorMessages.CustomerNotFound });

        var rules = await context.CParityGroupRules
            .AsNoTracking()
            .Where(r => r.CustomerId == customerId)
            .Select(r => r.ToViewModel())
            .ToListAsync();

        return Ok(rules);
    }

    /// <summary>
    /// Create a new parity group rule for a customer.
    /// </summary>
    /// <param name="model">CParityGroupRuleCreateModel</param>
    /// <returns>Created CParityGroupRuleViewModel</returns>
    [HttpPost]
    [SwaggerOperation(Summary = "Creates a new parity group rule",
        Description = "Creates a new parity group rule with the provided details.")]
    [SwaggerResponse(StatusCodes.Status201Created, "Parity group rule created successfully",
        typeof(CParityGroupRuleViewModel))]
    [SwaggerResponse(StatusCodes.Status400BadRequest, "Customer not found or Parity group not found or Rule already exists")]
    [SwaggerResponse(StatusCodes.Status403Forbidden, "User is not authorized to access this customer's data")]
    public async Task<IActionResult> Create(CParityGroupRuleCreateModel model)
    {
        // Yetkilendirme kontrolü
        var userCustomerId = User.GetCustomerId();
        if (userCustomerId != model.CustomerId)
            return Forbid();

        // Müşteri kontrolü
        if (!await context.Customers.AnyAsync(c => c.Id == model.CustomerId))
            return BadRequest(new { message = ErrorMessages.CustomerNotFound });

        // Kur grubu kontrolü
        if (!await context.ParityGroups.AnyAsync(pg => pg.Id == model.ParityGroupId))
            return BadRequest(new { message = ErrorMessages.ParityGroupNotFound });

        // Müşteri için bu kur grubu kuralı zaten var mı kontrolü
        if (await context.CParityGroupRules.AnyAsync(r =>
                r.CustomerId == model.CustomerId && r.ParityGroupId == model.ParityGroupId))
            return BadRequest(new { message = "Bu müşteri için bu kur grubu kuralı zaten tanımlı." });

        var entity = model.ToEntity();
        
        context.CParityGroupRules.Add(entity);
        await context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetByCustomerId), new { customerId = entity.CustomerId }, entity.ToViewModel());
    }

    /// <summary>
    /// Update an existing parity group rule.
    /// </summary>
    /// <param name="id">Rule ID</param>
    /// <param name="model">CParityGroupRuleUpdateModel</param>
    /// <returns>Updated CParityGroupRuleViewModel</returns>
    [HttpPut("{id:int}")]
    [SwaggerOperation(Summary = "Updates an existing parity group rule",
        Description = "Updates the details of an existing parity group rule based on the provided ID.")]
    [SwaggerResponse(StatusCodes.Status200OK, "Parity group rule updated successfully",
        typeof(CParityGroupRuleViewModel))]
    [SwaggerResponse(StatusCodes.Status404NotFound, "Rule not found")]
    [SwaggerResponse(StatusCodes.Status403Forbidden, "User is not authorized to access this customer's data")]
    public async Task<IActionResult> Update(int id, CParityGroupRuleUpdateModel model)
    {
        var rule = await context.CParityGroupRules
            .FirstOrDefaultAsync(r => r.Id == id);

        if (rule == null)
            return NotFound(new { message = "Kur grubu kuralı bulunamadı." });

        // Yetkilendirme kontrolü
        var userCustomerId = User.GetCustomerId();
        if (userCustomerId != rule.CustomerId)
            return Forbid();
        
        model.UpdateEntity(rule);
        await context.SaveChangesAsync();

        return Ok(rule.ToViewModel());
    }

    /// <summary>
    /// Delete a parity group rule.
    /// </summary>
    /// <param name="id">Rule ID</param>
    /// <returns>No content</returns>
    [HttpDelete("{id:int}")]
    [SwaggerOperation(Summary = "Deletes a parity group rule",
        Description = "Deletes a parity group rule based on the provided ID.")]
    [SwaggerResponse(StatusCodes.Status204NoContent, "Parity group rule deleted successfully")]
    [SwaggerResponse(StatusCodes.Status404NotFound, "Rule not found")]
    [SwaggerResponse(StatusCodes.Status403Forbidden, "User is not authorized to access this customer's data")]
    public async Task<IActionResult> Delete(int id)
    {
        var rule = await context.CParityGroupRules
            .FirstOrDefaultAsync(r => r.Id == id);

        if (rule == null)
            return NotFound(new { message = "Kur grubu kuralı bulunamadı." });

        // Yetkilendirme kontrolü
        var userCustomerId = User.GetCustomerId();
        if (userCustomerId != rule.CustomerId)
            return Forbid();

        context.CParityGroupRules.Remove(rule);
        await context.SaveChangesAsync();

        return NoContent();
    }
}