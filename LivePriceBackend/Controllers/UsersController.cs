using LivePriceBackend.Constants;
using LivePriceBackend.Data;
using LivePriceBackend.DTOs.User;
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
    public class UsersController(LivePriceDbContext context) : ControllerBase
    {
        /// <summary>
        /// Get all users.
        /// </summary>
        /// <returns>List of UserViewModel</returns>
        [HttpGet]
        [SwaggerResponse(StatusCodes.Status200OK, Type = typeof(IEnumerable<UserViewModel>))]
        public async Task<ActionResult<IEnumerable<UserViewModel>>> GetUsers()
        {
            return await context.Users
                .AsNoTracking()
                .Select(u => u.ToViewModel())
                .ToListAsync();
        }

        /// <summary>
        /// Get a user by ID.
        /// </summary>
        /// <param name="id">User ID</param>
        /// <returns>UserViewModel</returns>
        [HttpGet("{id:int}")]
        [SwaggerResponse(StatusCodes.Status200OK, Type = typeof(UserViewModel))]
        [SwaggerResponse(StatusCodes.Status404NotFound, Description = "User not found")]
        public async Task<ActionResult<UserViewModel>> GetUser(int id)
        {
            var user = await context.Users
                .AsNoTracking()
                .FirstOrDefaultAsync(u => u.Id == id);

            if (user == null)
                return NotFound(ErrorMessages.UserNotFound);

            return user.ToViewModel();
        }

        /// <summary>
        /// Get users by customer ID.
        /// </summary>
        /// <param name="customerId">Customer ID</param>
        /// <returns>List of UserViewModel</returns>
        [HttpGet("by-customer/{customerId:int}")]
        [SwaggerResponse(StatusCodes.Status200OK, Type = typeof(IEnumerable<UserViewModel>))]
        [SwaggerResponse(StatusCodes.Status404NotFound, Description = "No users found for the customer")]
        public async Task<ActionResult<IEnumerable<UserViewModel>>> GetByCustomerId(int customerId)
        {
            if (!await context.Users.AnyAsync(u => u.CustomerId == customerId))
                return NotFound(ErrorMessages.UserNotFound);

            return await context.Users
                .AsNoTracking()
                .Where(u => u.CustomerId == customerId)
                .Select(u => u.ToViewModel())
                .ToListAsync();
        }

        /// <summary>
        /// Create a new user.
        /// </summary>
        /// <param name="model">UserCreateModel</param>
        /// <returns>Created UserViewModel</returns>
        [HttpPost]
        [SwaggerResponse(StatusCodes.Status201Created, Type = typeof(UserViewModel))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, Description = "Username or Email already exists")]
        public async Task<ActionResult<UserViewModel>> CreateUser(UserCreateModel model)
        {
            if (await context.Users.AnyAsync(u => u.Username == model.Username))
                return BadRequest(ErrorMessages.UsernameAlreadyExists);

            if (await context.Users.AnyAsync(u => u.Email == model.Email))
                return BadRequest(ErrorMessages.EmailAlreadyExists);

            var user = model.ToEntity();
            context.Users.Add(user);
            await context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetUser), new { id = user.Id }, user.ToViewModel());
        }

        /// <summary>
        /// Update an existing user.
        /// </summary>
        /// <param name="id">User ID</param>
        /// <param name="model">UserUpdateModel</param>
        /// <returns>No content</returns>
        [HttpPut("{id:int}")]
        [SwaggerResponse(StatusCodes.Status204NoContent)]
        [SwaggerResponse(StatusCodes.Status400BadRequest, Description = ErrorMessages.UserOrEmailNotFound)]
        [SwaggerResponse(StatusCodes.Status404NotFound, Description = ErrorMessages.UserNotFound)]
        public async Task<IActionResult> UpdateUser(int id, UserUpdateModel model)
        {
            var user = await context.Users.FindAsync(id);

            if (user == null)
                return NotFound(ErrorMessages.UserNotFound);

            if (await context.Users.AnyAsync(u => u.Username == model.Username && u.Id != id))
                return BadRequest(ErrorMessages.UsernameAlreadyExists);

            if (await context.Users.AnyAsync(u => u.Email == model.Email && u.Id != id))
                return BadRequest(ErrorMessages.EmailAlreadyExists);

            model.UpdateEntity(user);
            await context.SaveChangesAsync();

            return NoContent();
        }

        /// <summary>
        /// Delete a user by ID.
        /// </summary>
        /// <param name="id">User ID</param>
        /// <returns>No content</returns>
        [HttpDelete("{id:int}")]
        [SwaggerResponse(StatusCodes.Status204NoContent)]
        [SwaggerResponse(StatusCodes.Status404NotFound, Description = "User not found")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            var user = await context.Users.FindAsync(id);

            if (user == null)
                return NotFound(ErrorMessages.UserNotFound);

            context.Users.Remove(user);
            await context.SaveChangesAsync();

            return NoContent();
        }
    }
}