using LivePriceBackend.Constants;
using LivePriceBackend.Data;
using LivePriceBackend.DTOs.Customer;
using LivePriceBackend.Extensions.EntityExtenders;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Swashbuckle.AspNetCore.Annotations;

namespace LivePriceBackend.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class CustomersController(LivePriceDbContext context) : ControllerBase
    {
        /// <summary>
        /// Get all customers.
        /// </summary>
        /// <returns>List of CustomerViewModel</returns>
        [HttpGet]
        [SwaggerOperation(Summary = "Retrieves all customers", Description = "Returns a list of all customers in the system.")]
        [SwaggerResponse(StatusCodes.Status200OK, "List of customers retrieved successfully", typeof(IEnumerable<CustomerViewModel>))]
        public async Task<ActionResult<IEnumerable<CustomerViewModel>>> GetCustomers()
        {
            return await context.Customers
                .AsNoTracking()
                .Select(c => c.ToViewModel())
                .ToListAsync();
        }

        /// <summary>
        /// Get a customer by ID.
        /// </summary>
        /// <param name="id">Customer ID</param>
        /// <returns>CustomerViewModel</returns>
        [HttpGet("{id:int}")]
        [SwaggerOperation(Summary = "Retrieves a customer by ID", Description = "Returns a customer based on the provided ID.")]
        [SwaggerResponse(StatusCodes.Status200OK, "Customer retrieved successfully", typeof(CustomerViewModel))]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Customer not found")]
        public async Task<ActionResult<CustomerViewModel>> GetCustomer(int id)
        {
            var customer = await context.Customers
                .AsNoTracking()
                .FirstOrDefaultAsync(c => c.Id == id);

            if (customer == null)
                return NotFound(new { message = ErrorMessages.CustomerNotFound });

            return customer.ToViewModel();
        }

        /// <summary>
        /// Create a new customer.
        /// </summary>
        /// <param name="model">CustomerCreateModel</param>
        /// <returns>Created CustomerViewModel</returns>
        [HttpPost]
        [SwaggerOperation(Summary = "Creates a new customer", Description = "Creates a new customer with the provided details.")]
        [SwaggerResponse(StatusCodes.Status201Created, "Customer created successfully", typeof(CustomerViewModel))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Customer name already exists")]
        public async Task<ActionResult<CustomerViewModel>> CreateCustomer(CustomerCreateModel model)
        {
            if (await context.Customers.AnyAsync(c => c.Name == model.Name))
                return BadRequest(new { message = ErrorMessages.CustomerNameAlreadyExists });

            var customer = model.ToEntity();
            customer.ApiKey = GenerateApiKey(); // Generate and assign API key
            context.Customers.Add(customer);
            await context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetCustomer), new { id = customer.Id }, customer.ToViewModel());
        }

        private static string GenerateApiKey()
        {
            return Guid.NewGuid().ToString("N"); // Generate a unique API key
        }

        /// <summary>
        /// Update an existing customer.
        /// </summary>
        /// <param name="id">Customer ID</param>
        /// <param name="model">CustomerUpdateModel</param>
        /// <returns>No content</returns>
        [HttpPut("{id:int}")]
        [SwaggerOperation(Summary = "Updates an existing customer", Description = "Updates the details of an existing customer based on the provided ID.")]
        [SwaggerResponse(StatusCodes.Status204NoContent, "Customer updated successfully")]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Customer name already exists")]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Customer not found")]
        public async Task<IActionResult> UpdateCustomer(int id, CustomerUpdateModel model)
        {
            var customer = await context.Customers.FindAsync(id);

            if (customer == null)
                return NotFound(new { message = ErrorMessages.CustomerNotFound });

            if (await context.Customers.AnyAsync(c => c.Name == model.Name && c.Id != id))
                return BadRequest(new { message = ErrorMessages.CustomerNameAlreadyExists });

            model.UpdateEntity(customer);
            await context.SaveChangesAsync();

            return NoContent();
        }

        /// <summary>
        /// Delete a customer by ID.
        /// </summary>
        /// <param name="id">Customer ID</param>
        /// <returns>No content</returns>
        [HttpDelete("{id:int}")]
        [SwaggerOperation(Summary = "Deletes a customer by ID", Description = "Deletes a customer based on the provided ID.")]
        [SwaggerResponse(StatusCodes.Status204NoContent, "Customer deleted successfully")]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Customer not found")]
        public async Task<IActionResult> DeleteCustomer(int id)
        {
            var customer = await context.Customers.FindAsync(id);

            if (customer == null)
                return NotFound(new { message = ErrorMessages.CustomerNotFound });

            context.Customers.Remove(customer);
            await context.SaveChangesAsync();

            return NoContent();
        }
    }
}