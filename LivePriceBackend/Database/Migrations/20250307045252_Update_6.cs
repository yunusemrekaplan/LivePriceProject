using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LivePriceBackend.Database.Migrations
{
    /// <inheritdoc />
    public partial class Update_6 : Migration
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
                    IsVisible = table.Column<bool>(type: "bit", nullable: false),
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
                    table.ForeignKey(
                        name: "FK_CParityGroupRules_Customers_CustomerId",
                        column: x => x.CustomerId,
                        principalTable: "Customers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CParityGroupRules_ParityGroups_ParityGroupId",
                        column: x => x.ParityGroupId,
                        principalTable: "ParityGroups",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CParityGroupRules_Users_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CParityGroupRules_Users_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CParityGroupRules_Users_UpdatedById",
                        column: x => x.UpdatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "CParityRules",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CustomerId = table.Column<int>(type: "int", nullable: false),
                    ParityId = table.Column<int>(type: "int", nullable: false),
                    IsVisible = table.Column<bool>(type: "bit", nullable: false),
                    SpreadRuleType = table.Column<int>(type: "int", nullable: true),
                    SpreadForAsk = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    SpreadForBid = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
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
                    table.ForeignKey(
                        name: "FK_CParityRules_Customers_CustomerId",
                        column: x => x.CustomerId,
                        principalTable: "Customers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CParityRules_Parities_ParityId",
                        column: x => x.ParityId,
                        principalTable: "Parities",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CParityRules_Users_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CParityRules_Users_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CParityRules_Users_UpdatedById",
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
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "CParityGroupRules");

            migrationBuilder.DropTable(
                name: "CParityRules");
        }
    }
}
