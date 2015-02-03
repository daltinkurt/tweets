<%@ WebHandler Language="C#" Class="TwitterHandler" %>
 
using System;
using System.Web;
using System.Net;
using Newtonsoft.Json.Linq;
using System.IO;
using System.Security.Cryptography;
using System.Text;
 
public class TwitterHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
 
        string url = "https://api.twitter.com/1.1/statuses/user_timeline.json";
        string q = "";
 
        var username = "daltinkurt"; // Twitter hesabınız
        var oauth_consumer_key = "8Rnx3IXlYbxxxxxxlhZtQtd";
        var oauth_consumer_secret = "AuCjtIxxxx30oI88OpLa4PnaR9WVDirxxxxxx";
        var oauth_token = "10145xxx-4q0qxxxx2grGHRf8M1upq19xxxx";
        var oauth_token_secret = "8gQSxxxxxTWFj6iSj7h36GlZbxxxxxx";
 
        // oauth implementation details
        var oauth_version = "1.0";
        var oauth_signature_method = "HMAC-SHA1";
 
        // unique request details
        var oauth_nonce = Convert.ToBase64String(new ASCIIEncoding().GetBytes(DateTime.Now.Ticks.ToString()));
        var timeSpan = DateTime.UtcNow
            - new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
        var oauth_timestamp = Convert.ToInt64(timeSpan.TotalSeconds).ToString();
 
 
        // create oauth signature
        var baseFormat = "oauth_consumer_key={0}&oauth_nonce={1}&oauth_signature_method={2}" +
                        "&oauth_timestamp={3}&oauth_token={4}&oauth_version={5}&q={6}";
 
        var baseString = string.Format(baseFormat,
                                    oauth_consumer_key,
                                    oauth_nonce,
                                    oauth_signature_method,
                                    oauth_timestamp,
                                    oauth_token,
                                    oauth_version,
                                    Uri.EscapeDataString(q)
                                    );
 
        baseString = string.Concat("GET&", Uri.EscapeDataString(url), "&", Uri.EscapeDataString(baseString));
 
        var compositeKey = string.Concat(Uri.EscapeDataString(oauth_consumer_secret),
                                "&", Uri.EscapeDataString(oauth_token_secret));
 
        string oauth_signature;
        using (HMACSHA1 hasher = new HMACSHA1(ASCIIEncoding.ASCII.GetBytes(compositeKey)))
        {
            oauth_signature = Convert.ToBase64String(
                hasher.ComputeHash(ASCIIEncoding.ASCII.GetBytes(baseString)));
        }
 
        // create the request header
        var headerFormat = "OAuth oauth_nonce=\"{0}\", oauth_signature_method=\"{1}\", " +
                           "oauth_timestamp=\"{2}\", oauth_consumer_key=\"{3}\", " +
                           "oauth_token=\"{4}\", oauth_signature=\"{5}\", " +
                           "oauth_version=\"{6}\"";
 
        var authHeader = string.Format(headerFormat,
                                Uri.EscapeDataString(oauth_nonce),
                                Uri.EscapeDataString(oauth_signature_method),
                                Uri.EscapeDataString(oauth_timestamp),
                                Uri.EscapeDataString(oauth_consumer_key),
                                Uri.EscapeDataString(oauth_token),
                                Uri.EscapeDataString(oauth_signature),
                                Uri.EscapeDataString(oauth_version)
                        );
 
 
 
        ServicePointManager.Expect100Continue = false;
 
        // make the request
        var postBody = "q=" + Uri.EscapeDataString(q);//
        url += "?" + postBody;
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
        request.Headers.Add("Authorization", authHeader);
        request.Method = "GET";
        request.ContentType = "application/x-www-form-urlencoded";
        var response = (HttpWebResponse)request.GetResponse();
        var reader = new StreamReader(response.GetResponseStream());
        var objText = reader.ReadToEnd();
 
 
        StringBuilder sb = new StringBuilder();
        //try
        //{
        JArray jsonDat = JArray.Parse(objText);
        sb.Append("[");
        bool ilk = true;
        for (int x = 0; x < jsonDat.Count; x++)
        {
            string twit_url = string.Format("http://twitter.com/{0}/status/{1}", username, jsonDat[x]["id"].Value<long>());
            string twit_text = jsonDat[x]["text"].Value<string>();
            twit_text = System.Web.HttpUtility.JavaScriptStringEncode(twit_text);
            twit_text = twit_text.Replace('\n', ' ').SoldanMetinAl(120);
 
            if (!ilk)
            {
                sb.Append(",");
            }
 
            sb.AppendFormat(@"{{""text"":""{0}"",  ""url"":""{1}""}}", twit_text, twit_url);
 
            ilk = false;
        }
        sb.Append("]");
        context.Response.Write(sb.ToString());
        //}
        //catch
        //{
        //    context.Response.Write("[]");
        //}
    }
 
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
 
}
