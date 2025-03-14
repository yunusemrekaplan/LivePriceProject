using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LivePriceBackend.Database.Migrations
{
    /// <inheritdoc />
    public partial class Initial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "CParityGroupRules",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CustomerId = table.Column<int>(type: "int", nullable: false),
                    ParityGroupId = table.Column<int>(type: "int", nullable: false),
                    IsVisible = table.Column<bool>(type: "bit", nullable: false, defaultValue: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    CreatedById = table.Column<int>(type: "int", nullable: true),
                    UpdatedById = table.Column<int>(type: "int", nullable: true),
                    DeletedById = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CParityGroupRules", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "CParityRules",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CustomerId = table.Column<int>(type: "int", nullable: false),
                    ParityId = table.Column<int>(type: "int", nullable: false),
                    IsVisible = table.Column<bool>(type: "bit", nullable: false, defaultValue: true),
                    SpreadRuleType = table.Column<int>(type: "int", nullable: true),
                    SpreadForAsk = table.Column<decimal>(type: "decimal(18,6)", nullable: true),
                    SpreadForBid = table.Column<decimal>(type: "decimal(18,6)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    CreatedById = table.Column<int>(type: "int", nullable: true),
                    UpdatedById = table.Column<int>(type: "int", nullable: true),
                    DeletedById = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CParityRules", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Customers",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    ApiKey = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    IsEnabled = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    CreatedById = table.Column<int>(type: "int", nullable: true),
                    UpdatedById = table.Column<int>(type: "int", nullable: true),
                    DeletedById = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Customers", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Surname = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Username = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    PasswordHash = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    Role = table.Column<int>(type: "int", nullable: false),
                    CustomerId = table.Column<int>(type: "int", nullable: true),
                    RefreshToken = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    RefreshTokenExpiry = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    CreatedById = table.Column<int>(type: "int", nullable: true),
                    UpdatedById = table.Column<int>(type: "int", nullable: true),
                    DeletedById = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Users_Customers_CustomerId",
                        column: x => x.CustomerId,
                        principalTable: "Customers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Users_Users_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Users_Users_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Users_Users_UpdatedById",
                        column: x => x.UpdatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "ParityGroups",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    IsEnabled = table.Column<bool>(type: "bit", nullable: false, defaultValue: true),
                    OrderIndex = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    CreatedById = table.Column<int>(type: "int", nullable: true),
                    UpdatedById = table.Column<int>(type: "int", nullable: true),
                    DeletedById = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ParityGroups", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ParityGroups_Users_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_ParityGroups_Users_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_ParityGroups_Users_UpdatedById",
                        column: x => x.UpdatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Parities",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Symbol = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    RawSymbol = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    IsEnabled = table.Column<bool>(type: "bit", nullable: false, defaultValue: true),
                    OrderIndex = table.Column<int>(type: "int", nullable: false),
                    Scale = table.Column<int>(type: "int", nullable: false, defaultValue: 2),
                    SpreadRuleType = table.Column<int>(type: "int", nullable: true),
                    SpreadForAsk = table.Column<decimal>(type: "decimal(18,6)", nullable: true),
                    SpreadForBid = table.Column<decimal>(type: "decimal(18,6)", nullable: true),
                    ParityGroupId = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    CreatedById = table.Column<int>(type: "int", nullable: true),
                    UpdatedById = table.Column<int>(type: "int", nullable: true),
                    DeletedById = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Parities", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Parities_ParityGroups_ParityGroupId",
                        column: x => x.ParityGroupId,
                        principalTable: "ParityGroups",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Parities_Users_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Parities_Users_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Parities_Users_UpdatedById",
                        column: x => x.UpdatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_CParityGroupRules_CreatedById",
                table: "CParityGroupRules",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_CParityGroupRules_CustomerId",
                table: "CParityGroupRules",
                column: "CustomerId");

            migrationBuilder.CreateIndex(
                name: "IX_CParityGroupRules_DeletedById",
                table: "CParityGroupRules",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_CParityGroupRules_ParityGroupId",
                table: "CParityGroupRules",
                column: "ParityGroupId");

            migrationBuilder.CreateIndex(
                name: "IX_CParityGroupRules_UpdatedById",
                table: "CParityGroupRules",
                column: "UpdatedById");

            migrationBuilder.CreateIndex(
                name: "IX_CParityRules_CreatedById",
                table: "CParityRules",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_CParityRules_CustomerId",
                table: "CParityRules",
                column: "CustomerId");

            migrationBuilder.CreateIndex(
                name: "IX_CParityRules_DeletedById",
                table: "CParityRules",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_CParityRules_ParityId",
                table: "CParityRules",
                column: "ParityId");

            migrationBuilder.CreateIndex(
                name: "IX_CParityRules_UpdatedById",
                table: "CParityRules",
                column: "UpdatedById");

            migrationBuilder.CreateIndex(
                name: "IX_Customers_CreatedById",
                table: "Customers",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_Customers_DeletedById",
                table: "Customers",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_Customers_UpdatedById",
                table: "Customers",
                column: "UpdatedById");

            migrationBuilder.CreateIndex(
                name: "IX_Parities_CreatedById",
                table: "Parities",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_Parities_DeletedById",
                table: "Parities",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_Parities_ParityGroupId",
                table: "Parities",
                column: "ParityGroupId");

            migrationBuilder.CreateIndex(
                name: "IX_Parities_UpdatedById",
                table: "Parities",
                column: "UpdatedById");

            migrationBuilder.CreateIndex(
                name: "IX_ParityGroups_CreatedById",
                table: "ParityGroups",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_ParityGroups_DeletedById",
                table: "ParityGroups",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_ParityGroups_UpdatedById",
                table: "ParityGroups",
                column: "UpdatedById");

            migrationBuilder.CreateIndex(
                name: "IX_Users_CreatedById",
                table: "Users",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_Users_CustomerId",
                table: "Users",
                column: "CustomerId");

            migrationBuilder.CreateIndex(
                name: "IX_Users_DeletedById",
                table: "Users",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_Users_UpdatedById",
                table: "Users",
                column: "UpdatedById");

            migrationBuilder.AddForeignKey(
                name: "FK_CParityGroupRules_Customers_CustomerId",
                table: "CParityGroupRules",
                column: "CustomerId",
                principalTable: "Customers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_CParityGroupRules_ParityGroups_ParityGroupId",
                table: "CParityGroupRules",
                column: "ParityGroupId",
                principalTable: "ParityGroups",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_CParityGroupRules_Users_CreatedById",
                table: "CParityGroupRules",
                column: "CreatedById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_CParityGroupRules_Users_DeletedById",
                table: "CParityGroupRules",
                column: "DeletedById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_CParityGroupRules_Users_UpdatedById",
                table: "CParityGroupRules",
                column: "UpdatedById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_CParityRules_Customers_CustomerId",
                table: "CParityRules",
                column: "CustomerId",
                principalTable: "Customers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_CParityRules_Parities_ParityId",
                table: "CParityRules",
                column: "ParityId",
                principalTable: "Parities",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_CParityRules_Users_CreatedById",
                table: "CParityRules",
                column: "CreatedById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_CParityRules_Users_DeletedById",
                table: "CParityRules",
                column: "DeletedById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_CParityRules_Users_UpdatedById",
                table: "CParityRules",
                column: "UpdatedById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Customers_Users_CreatedById",
                table: "Customers",
                column: "CreatedById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Customers_Users_DeletedById",
                table: "Customers",
                column: "DeletedById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Customers_Users_UpdatedById",
                table: "Customers",
                column: "UpdatedById",
                principalTable: "Users",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Users_Customers_CustomerId",
                table: "Users");

            migrationBuilder.DropTable(
                name: "CParityGroupRules");

            migrationBuilder.DropTable(
                name: "CParityRules");

            migrationBuilder.DropTable(
                name: "Parities");

            migrationBuilder.DropTable(
                name: "ParityGroups");

            migrationBuilder.DropTable(
                name: "Customers");

            migrationBuilder.DropTable(
                name: "Users");
        }
    }
}
