using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LivePriceBackend.Database.Migrations
{
    /// <inheritdoc />
    public partial class Update_4 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AdminPriceRules");

            migrationBuilder.RenameColumn(
                name: "PriceRuleType",
                table: "CustomerPriceRules",
                newName: "SpreadRuleType");

            migrationBuilder.AddColumn<decimal>(
                name: "SpreadForAsk",
                table: "Parities",
                type: "decimal(18,6)",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "SpreadForBid",
                table: "Parities",
                type: "decimal(18,6)",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "SpreadRuleType",
                table: "Parities",
                type: "int",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "SpreadForAsk",
                table: "Parities");

            migrationBuilder.DropColumn(
                name: "SpreadForBid",
                table: "Parities");

            migrationBuilder.DropColumn(
                name: "SpreadRuleType",
                table: "Parities");

            migrationBuilder.RenameColumn(
                name: "SpreadRuleType",
                table: "CustomerPriceRules",
                newName: "PriceRuleType");

            migrationBuilder.CreateTable(
                name: "AdminPriceRules",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CreatedById = table.Column<int>(type: "int", nullable: true),
                    DeletedById = table.Column<int>(type: "int", nullable: true),
                    ParityId = table.Column<int>(type: "int", nullable: false),
                    UpdatedById = table.Column<int>(type: "int", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    PriceRuleType = table.Column<int>(type: "int", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    ValueForAsk = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    ValueForBid = table.Column<decimal>(type: "decimal(18,2)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AdminPriceRules", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AdminPriceRules_Parities_ParityId",
                        column: x => x.ParityId,
                        principalTable: "Parities",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AdminPriceRules_Users_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AdminPriceRules_Users_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AdminPriceRules_Users_UpdatedById",
                        column: x => x.UpdatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_AdminPriceRules_CreatedById",
                table: "AdminPriceRules",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_AdminPriceRules_DeletedById",
                table: "AdminPriceRules",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_AdminPriceRules_ParityId",
                table: "AdminPriceRules",
                column: "ParityId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_AdminPriceRules_UpdatedById",
                table: "AdminPriceRules",
                column: "UpdatedById");
        }
    }
}
