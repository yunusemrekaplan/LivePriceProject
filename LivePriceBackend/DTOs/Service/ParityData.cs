namespace LivePriceBackend.DTOs.Service;

public class ParityData
{
    public int Id { get; set; }
    public required string Name { get; set; }
    public required string Symbol { get; set; }
    public int OrderIndex { get; set; }
    public required string GroupName { get; set; }
    public int GroupId { get; set; }
    public int GroupOrderIndex { get; set; }
    public decimal Ask { get; set; }
    public decimal Bid { get; set; }
    public decimal Close { get; set; }
    public decimal High { get; set; }
    public decimal Low { get; set; }
    public decimal Change { get; set; }
    public DateTime UpdateTime { get; set; }
}