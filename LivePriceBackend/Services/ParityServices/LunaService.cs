using System.Globalization;
using LivePriceBackend.DTOs;
using LivePriceBackend.DTOs.Service;
using LivePriceBackend.Entities;
using Newtonsoft.Json.Linq;

namespace LivePriceBackend.Services.ParityServices;

public static class LunaService
{
    private const string Endpoint = "https://kapalicarsi.apiluna.org/";

    public static async Task<List<ParityHamData>?> GetAll()
    {
        try
        {
            using var httpClient = new HttpClient();
            var response = await httpClient.GetStringAsync(Endpoint);
            var json = JArray.Parse(response);

            return json.Select(item => new ParityHamData
                {
                    Symbol = item["code"]?.ToString() ?? string.Empty,
                    Ask = decimal.Parse(item["satis"]?.ToString() ?? "0"),
                    Bid = decimal.Parse(item["alis"]?.ToString() ?? "0"),
                    Date = DateTime.Parse(item["tarih"]?.ToString() ?? DateTime.MinValue.ToString(CultureInfo.InvariantCulture)),
                    Low = decimal.Parse(item["dusuk"]?.ToString() ?? "0"),
                    High = decimal.Parse(item["yuksek"]?.ToString() ?? "0"),
                    Close = decimal.Parse(item["kapanis"]?.ToString() ?? "0")
                })
                .ToList();
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            return null;
        }
    }
}