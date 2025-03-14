using LivePriceBackend.Constants.Enums;
using LivePriceBackend.Entities;
using LivePriceBackend.Services.ParityServices;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace LivePriceBackend.Tests;

public class ParityCalculationServiceTests
{
    private readonly Mock<ILogger<ParityCalculationService>> _mockLogger;
    private readonly ParityCalculationService _service;

    public ParityCalculationServiceTests()
    {
        _mockLogger = new Mock<ILogger<ParityCalculationService>>();
        _service = new ParityCalculationService(_mockLogger.Object);
    }

    [Fact]
    public void ApplySpread_WhenParityRuleIsNull_ReturnsOriginalValues()
    {
        // Arrange
        decimal rawAsk = 10.5m;
        decimal rawBid = 10.0m;
        CParityRule? parityRule = null;

        // Act
        var (ask, bid) = _service.ApplySpread(rawAsk, rawBid, parityRule);

        // Assert
        Assert.Equal(rawAsk, ask);
        Assert.Equal(rawBid, bid);
    }

    [Fact]
    public void ApplySpread_WhenSpreadRuleTypeIsNull_ReturnsOriginalValues()
    {
        // Arrange
        decimal rawAsk = 10.5m;
        decimal rawBid = 10.0m;
        var parityRule = new CParityRule
        {
            CustomerId = 1,
            ParityId = 1,
            SpreadRuleType = null,
            SpreadForAsk = 0.5m,
            SpreadForBid = 0.3m
        };

        // Act
        var (ask, bid) = _service.ApplySpread(rawAsk, rawBid, parityRule);

        // Assert
        Assert.Equal(rawAsk, ask);
        Assert.Equal(rawBid, bid);
    }

    [Fact]
    public void ApplySpread_WithPercentageRule_AppliesPercentageCorrectly()
    {
        // Arrange
        decimal rawAsk = 100.0m;
        decimal rawBid = 99.0m;
        var parityRule = new CParityRule
        {
            CustomerId = 1,
            ParityId = 1,
            SpreadRuleType = SpreadRuleType.Percentage,
            SpreadForAsk = 5.0m, // 5%
            SpreadForBid = 3.0m  // 3%
        };

        // Act
        var (ask, bid) = _service.ApplySpread(rawAsk, rawBid, parityRule);

        // Assert
        Assert.Equal(105.0m, ask); // 100 + 5%
        Assert.Equal(96.03m, bid); // 99 - 3%
    }

    [Fact]
    public void ApplySpread_WithFixedRule_AppliesFixedAmountCorrectly()
    {
        // Arrange
        decimal rawAsk = 100.0m;
        decimal rawBid = 99.0m;
        var parityRule = new CParityRule
        {
            CustomerId = 1,
            ParityId = 1,
            SpreadRuleType = SpreadRuleType.Fixed,
            SpreadForAsk = 1.5m,
            SpreadForBid = 0.5m
        };

        // Act
        var (ask, bid) = _service.ApplySpread(rawAsk, rawBid, parityRule);

        // Assert
        Assert.Equal(101.5m, ask); // 100 + 1.5
        Assert.Equal(98.5m, bid);  // 99 - 0.5
    }

    [Fact]
    public void CalculateChangeRate_WhenClosePriceIsZero_ReturnsZero()
    {
        // Arrange
        decimal currentBid = 10.5m;
        decimal closePrice = 0;

        // Act
        var result = _service.CalculateChangeRate(currentBid, closePrice);

        // Assert
        Assert.Equal(0m, result);
    }

    [Fact]
    public void CalculateChangeRate_WhenBidHigherThanClose_ReturnsPositiveRate()
    {
        // Arrange
        decimal currentBid = 110.0m;
        decimal closePrice = 100.0m;

        // Act
        var result = _service.CalculateChangeRate(currentBid, closePrice);

        // Assert
        Assert.Equal(10.0m, result); // (110-100)/100 * 100 = 10%
    }

    [Fact]
    public void CalculateChangeRate_WhenBidLowerThanClose_ReturnsNegativeRate()
    {
        // Arrange
        decimal currentBid = 90.0m;
        decimal closePrice = 100.0m;

        // Act
        var result = _service.CalculateChangeRate(currentBid, closePrice);

        // Assert
        Assert.Equal(-10.0m, result); // (90-100)/100 * 100 = -10%
    }

    [Theory]
    [InlineData(12.3456, 2, 12.35)]
    [InlineData(12.3456, 3, 12.346)]
    [InlineData(12.3456, 0, 12)]
    [InlineData(12.3456, -1, 12)]
    [InlineData(12.3456, 29, 12.3456)] // Maksimum 28 olmalı
    public void RoundPrice_RoundsToCorrectScale(decimal price, int scale, decimal expected)
    {
        // Act
        var result = _service.RoundPrice(price, scale);

        // Assert
        Assert.Equal(expected, result);
    }
} 