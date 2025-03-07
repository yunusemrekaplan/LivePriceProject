using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LivePriceBackend.Database.Migrations
{
    /// <inheritdoc />
    public partial class Update_5 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "CustomerParityGroupVisibilities");

            migrationBuilder.DropTable(
                name: "CustomerParityVisibilities");

            migrationBuilder.DropTable(
                name: "CustomerPriceRules");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "CustomerParityGroupVisibilities",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CreatedById = table.Column<int>(type: "int", nullable: true),
                    CustomerId = table.Column<int>(type: "int", nullable: false),
                    DeletedById = table.Column<int>(type: "int", nullable: true),
                    ParityGroupId = table.Column<int>(type: "int", nullable: false),
                    UpdatedById = table.Column<int>(type: "int", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    IsVisible = table.Column<bool>(type: "bit", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CustomerParityGroupVisibilities", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CustomerParityGroupVisibilities_Customers_CustomerId",
                        column: x => x.CustomerId,
                        principalTable: "Customers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CustomerParityGroupVisibilities_ParityGroups_ParityGroupId",
                        column: x => x.ParityGroupId,
                        principalTable: "ParityGroups",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CustomerParityGroupVisibilities_Users_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CustomerParityGroupVisibilities_Users_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CustomerParityGroupVisibilities_Users_UpdatedById",
                        column: x => x.UpdatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "CustomerParityVisibilities",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CreatedById = table.Column<int>(type: "int", nullable: true),
                    CustomerId = table.Column<int>(type: "int", nullable: false),
                    DeletedById = table.Column<int>(type: "int", nullable: true),
                    ParityId = table.Column<int>(type: "int", nullable: false),
                    UpdatedById = table.Column<int>(type: "int", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    IsVisible = table.Column<bool>(type: "bit", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CustomerParityVisibilities", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CustomerParityVisibilities_Customers_CustomerId",
                        column: x => x.CustomerId,
                        principalTable: "Customers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CustomerParityVisibilities_Parities_ParityId",
                        column: x => x.ParityId,
                        principalTable: "Parities",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CustomerParityVisibilities_Users_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CustomerParityVisibilities_Users_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CustomerParityVisibilities_Users_UpdatedById",
                        column: x => x.UpdatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "CustomerPriceRules",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CreatedById = table.Column<int>(type: "int", nullable: true),
                    CustomerId = table.Column<int>(type: "int", nullable: false),
                    DeletedById = table.Column<int>(type: "int", nullable: true),
                    ParityId = table.Column<int>(type: "int", nullable: false),
                    UpdatedById = table.Column<int>(type: "int", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    SpreadRuleType = table.Column<int>(type: "int", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    Value = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CustomerPriceRules", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CustomerPriceRules_Customers_CustomerId",
                        column: x => x.CustomerId,
                        principalTable: "Customers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CustomerPriceRules_Parities_ParityId",
                        column: x => x.ParityId,
                        principalTable: "Parities",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CustomerPriceRules_Users_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CustomerPriceRules_Users_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CustomerPriceRules_Users_UpdatedById",
                        column: x => x.UpdatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityGroupVisibilities_CreatedById",
                table: "CustomerParityGroupVisibilities",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityGroupVisibilities_CustomerId",
                table: "CustomerParityGroupVisibilities",
                column: "CustomerId");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityGroupVisibilities_DeletedById",
                table: "CustomerParityGroupVisibilities",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityGroupVisibilities_ParityGroupId",
                table: "CustomerParityGroupVisibilities",
                column: "ParityGroupId");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityGroupVisibilities_UpdatedById",
                table: "CustomerParityGroupVisibilities",
                column: "UpdatedById");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityVisibilities_CreatedById",
                table: "CustomerParityVisibilities",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityVisibilities_CustomerId",
                table: "CustomerParityVisibilities",
                column: "CustomerId");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityVisibilities_DeletedById",
                table: "CustomerParityVisibilities",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityVisibilities_ParityId",
                table: "CustomerParityVisibilities",
                column: "ParityId");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityVisibilities_UpdatedById",
                table: "CustomerParityVisibilities",
                column: "UpdatedById");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerPriceRules_CreatedById",
                table: "CustomerPriceRules",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerPriceRules_CustomerId",
                table: "CustomerPriceRules",
                column: "CustomerId");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerPriceRules_DeletedById",
                table: "CustomerPriceRules",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerPriceRules_ParityId",
                table: "CustomerPriceRules",
                column: "ParityId");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerPriceRules_UpdatedById",
                table: "CustomerPriceRules",
                column: "UpdatedById");
        }
    }
}
