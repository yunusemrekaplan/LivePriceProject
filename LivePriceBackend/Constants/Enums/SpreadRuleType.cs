using System.ComponentModel;

namespace LivePriceBackend.Constants.Enums;

public enum SpreadRuleType
{
    [Description("Fixed")]
    Fixed = 0,       // Sabit TL ekleme/çıkarma
    
    [Description("Percentage")]
    Percentage = 1   // Yüzde bazlı ekleme/çıkarma
}