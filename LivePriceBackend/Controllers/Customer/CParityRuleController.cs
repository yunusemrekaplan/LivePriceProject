using LivePriceBackend.Constants;
using LivePriceBackend.Data;
using LivePriceBackend.DTOs.CParityRule;
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
[Route("api/customer/parity-rules")]
public class CParityRuleController(LivePriceDbContext context) : ControllerBase
{
    /// <summary>
    /// Get all parity rules for a customer.
    /// </summary>
    /// <param name="customerId">Customer ID</param>
    /// <returns>List of CParityRuleViewModel</returns>
    [HttpGet("by-customer/{customerId:int}")]
    [SwaggerOperation(Summary = "Retrieves all parity rules for a customer",
        Description = "Returns a list of all parity rules for the specified customer.")]
    [SwaggerResponse(StatusCodes.Status200OK, "List of parity rules retrieved successfully",
        typeof(IEnumerable<CParityRuleViewModel>))]
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

        var rules = await context.CParityRules
            .AsNoTracking()
            .Where(r => r.CustomerId == customerId)
            .Select(r => r.ToViewModel())
            .ToListAsync();

        return Ok(rules);
    }

    /// <summary>
    /// Create a new parity rule for a customer.
    /// </summary>
    /// <param name="model">CParityRuleCreateModel</param>
    /// <returns>Created CParityRuleViewModel</returns>
    [HttpPost]
    [SwaggerOperation(Summary = "Creates a new parity rule",
        Description = "Creates a new parity rule with the provided details.")]
    [SwaggerResponse(StatusCodes.Status201Created, "Parity rule created successfully",
        typeof(CParityRuleViewModel))]
    [SwaggerResponse(StatusCodes.Status400BadRequest, "Customer not found or Parity not found or Rule already exists")]
    [SwaggerResponse(StatusCodes.Status403Forbidden, "User is not authorized to access this customer's data")]
    public async Task<IActionResult> Create(CParityRuleCreateModel model)
    {
        // Yetkilendirme kontrolü
        var userCustomerId = User.GetCustomerId();
        if (userCustomerId != model.CustomerId)
            return Forbid();

        // Müşteri kontrolü
        if (!await context.Customers.AnyAsync(c => c.Id == model.CustomerId))
            return BadRequest(new { message = ErrorMessages.CustomerNotFound });

        // Kur kontrolü
        if (!await context.Parities.AnyAsync(p => p.Id == model.ParityId))
            return BadRequest(new { message = ErrorMessages.ParityNotFound });

        // Müşteri için bu kur kuralı zaten var mı kontrolü
        if (await context.CParityRules.AnyAsync(r =>
                r.CustomerId == model.CustomerId && r.ParityId == model.ParityId))
            return BadRequest(new { message = "Bu müşteri için bu kur kuralı zaten tanımlı." });
        ;

        var entity = model.ToEntity();
        
        context.CParityRules.Add(entity);
        await context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetByCustomerId), new { customerId = entity.CustomerId }, entity.ToViewModel());
    }

    /// <summary>
    /// Update an existing parity rule.
    /// </summary>
    /// <param name="id">Rule ID</param>
    /// <param name="model">CParityRuleUpdateModel</param>
    /// <returns>Updated CParityRuleViewModel</returns>
    [HttpPut("{id:int}")]
    [SwaggerOperation(Summary = "Updates an existing parity rule",
        Description = "Updates the details of an existing parity rule based on the provided ID.")]
    [SwaggerResponse(StatusCodes.Status200OK, "Parity rule updated successfully",
        typeof(CParityRuleViewModel))]
    [SwaggerResponse(StatusCodes.Status404NotFound, "Rule not found")]
    [SwaggerResponse(StatusCodes.Status403Forbidden, "User is not authorized to access this customer's data")]
    public async Task<IActionResult> Update(int id, CParityRuleUpdateModel model)
    {
        var rule = await context.CParityRules
            .FirstOrDefaultAsync(r => r.Id == id);

        if (rule == null)
            return NotFound(new { message = "Kur kuralı bulunamadı." });

        // Yetkilendirme kontrolü
        var userCustomerId = User.GetCustomerId();
        if (userCustomerId != rule.CustomerId)
            return Forbid();

        model.UpdateEntity(rule);
        await context.SaveChangesAsync();
        
        return Ok(rule.ToViewModel());
    }

    /// <summary>
    /// Delete a parity rule.
    /// </summary>
    /// <param name="id">Rule ID</param>
    /// <returns>No content</returns>
    [HttpDelete("{id:int}")]
    [SwaggerOperation(Summary = "Deletes a parity rule",
        Description = "Deletes a parity rule based on the provided ID.")]
    [SwaggerResponse(StatusCodes.Status204NoContent, "Parity rule deleted successfully")]
    [SwaggerResponse(StatusCodes.Status404NotFound, "Rule not found")]
    [SwaggerResponse(StatusCodes.Status403Forbidden, "User is not authorized to access this customer's data")]
    public async Task<IActionResult> Delete(int id)
    {
        var rule = await context.CParityRules
            .FirstOrDefaultAsync(r => r.Id == id);

        if (rule == null)
            return NotFound(new { message = "Kur kuralı bulunamadı." });

        // Yetkilendirme kontrolü
        var userCustomerId = User.GetCustomerId();
        if (userCustomerId != rule.CustomerId)
            return Forbid();

        context.CParityRules.Remove(rule);
        await context.SaveChangesAsync();

        return NoContent();
    }
}