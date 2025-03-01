namespace LivePriceBackend.Entities;

public class ParityHamData
{
    public required string Symbol { get; set; }
    
    public decimal Ask { get; set; }
    
    public decimal Bid { get; set; }
    
    public DateTime Date { get; set; }
    
    public decimal Low { get; set; }
    
    public decimal High { get; set; }
    
    public decimal Close { get; set; }
}