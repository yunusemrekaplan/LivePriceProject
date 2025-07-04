﻿using LivePriceBackend.DTOs.Parity;
using LivePriceBackend.Entities;

namespace LivePriceBackend.Extensions.EntityExtenders;

public static class ParityExtender
{
    public static ParityViewModel ToViewModel(this Parity parity)
    {
        return new ParityViewModel
        {
            Id = parity.Id,
            Name = parity.Name,
            Symbol = parity.Symbol,
            RawSymbol = parity.RawSymbol,
            RawMarketCode = parity.RawMarketCode,
            IsEnabled = parity.IsEnabled,
            OrderIndex = parity.OrderIndex,
            Scale = parity.Scale,
            SpreadRuleType = parity.SpreadRuleType,
            SpreadForAsk = parity.SpreadForAsk,
            SpreadForBid = parity.SpreadForBid,
            ParityGroupId = parity.ParityGroupId,
            CreatedAt = parity.CreatedAt,
            CreatedById = parity.CreatedById,
            UpdatedAt = parity.UpdatedAt,
            UpdatedById = parity.UpdatedById
        };
    }

    public static Parity ToEntity(this ParityCreateModel parityCreateModel)
    {
        return new Parity
        {
            Name = parityCreateModel.Name,
            Symbol = parityCreateModel.Symbol,
            RawSymbol = parityCreateModel.RawSymbol,
            RawMarketCode = parityCreateModel.RawMarketCode,
            IsEnabled = parityCreateModel.IsEnabled,
            OrderIndex = parityCreateModel.OrderIndex,
            Scale = parityCreateModel.Scale,
            SpreadRuleType = parityCreateModel.SpreadRuleType,
            SpreadForAsk = parityCreateModel.SpreadForAsk,
            SpreadForBid = parityCreateModel.SpreadForBid,
            ParityGroupId = parityCreateModel.ParityGroupId,
        };
    }

    public static void UpdateEntity(this ParityUpdateModel parityUpdateModel, Parity parity)
    {
        parity.Name = parityUpdateModel.Name ?? parity.Name;
        parity.Symbol = parityUpdateModel.Symbol ?? parity.Symbol;
        parity.RawSymbol = parityUpdateModel.RawSymbol ?? parity.RawSymbol;
        parity.RawMarketCode = parityUpdateModel.RawMarketCode;
        parity.IsEnabled = parityUpdateModel.IsEnabled;
        parity.OrderIndex = parityUpdateModel.OrderIndex;
        parity.Scale = parityUpdateModel.Scale;
        parity.SpreadRuleType = parityUpdateModel.SpreadRuleType;
        parity.SpreadForAsk = parityUpdateModel.SpreadForAsk;
        parity.SpreadForBid = parityUpdateModel.SpreadForBid;
        parity.ParityGroupId = parityUpdateModel.ParityGroupId;
    }
    
    public static ParityCustomerViewModel ToCustomerViewModel(this Parity parity, CParityRule? parityRule)
    {
        return new ParityCustomerViewModel
        {
            Id = parity.Id,
            Name = parity.Name,
            Symbol = parity.Symbol,
            IsVisible = parityRule?.IsVisible ?? true,
            SpreadRuleType = parityRule?.SpreadRuleType,
            SpreadForAsk = parityRule?.SpreadForAsk,
            SpreadForBid = parityRule?.SpreadForBid,
            ParityGroupId = parity.ParityGroupId
        };
    }
}