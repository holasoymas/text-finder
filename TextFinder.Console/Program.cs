using UglyToad.PdfPig;

public class Program
{
  static void Main(String[] args)
  {
    if (args.Length < 2)
    {
      Console.ForegroundColor = ConsoleColor.Red;
      Console.WriteLine("Error: Invalid Arguments");
      Console.WriteLine("Usage: text-finder <file-path> <search-string>");
      Console.ResetColor();
      return;
    }

    string file = args[0];
    string searchString = args[1];

    using (PdfDocument pdf = PdfDocument.Open(file))
    {
      int noOfPages = pdf.NumberOfPages;

      Console.ForegroundColor = ConsoleColor.Blue;
      Console.Write("Scanning ..... page ");
      Console.ResetColor();

      for (int i = 1; i <= noOfPages; i++)
      {
        // Update the page number dynamically on the same line
        Console.SetCursorPosition(20, Console.CursorTop); // Move cursor to overwrite the page number
        Console.Write($"{i}"); // Write the current page number

        string pageText = pdf.GetPage(i).Text;

        if (pageText.Contains(searchString, StringComparison.OrdinalIgnoreCase))
        {
          string fullSentence = ExtractFullSentence(pageText, searchString);

          Console.ForegroundColor = ConsoleColor.Green;
          Console.WriteLine("\n\n---------------------------------------------");
          Console.WriteLine($"Match Found!");
          Console.ResetColor();

          Console.WriteLine();
          Console.Write($"- Page Number: ");
          Console.ForegroundColor = ConsoleColor.Green;
          Console.WriteLine($"{i}");
          Console.ResetColor();

          Console.WriteLine();
          Console.Write($"- Input Sentence : ");
          Console.ForegroundColor = ConsoleColor.Green;
          Console.WriteLine($"\"{searchString}\"");
          Console.ResetColor();

          Console.WriteLine();
          Console.Write($"- Full Sentence: ");
          Console.ForegroundColor = ConsoleColor.Green;
          Console.WriteLine($"\"{fullSentence}\"");
          Console.ResetColor();

          Console.ForegroundColor = ConsoleColor.Green;
          Console.WriteLine("---------------------------------------------\n");
          Console.ResetColor();

          return;
        }
      }

      Console.ForegroundColor = ConsoleColor.Red;
      Console.WriteLine("\n---------------------------------------------");
      Console.WriteLine("No match found in the document.");
      Console.WriteLine("-----------------------------------------------");
      Console.ResetColor();
    }

    static string ExtractFullSentence(string text, string subSentence)
    {
      int index = text.IndexOf(subSentence, StringComparison.OrdinalIgnoreCase);
      if (index == -1)
      {
        throw new ArgumentException("Sub-sentence not found in the text.");
      }

      // Find the start of the sentence (preceding period or start of text)
      int startIndex = text.LastIndexOf('.', index) + 1;
      if (startIndex == -1)
      {
        startIndex = index; // No preceding period, start from the substring 
      }

      // Find the end of the sentence (next period or end of text)
      int endIndex = text.IndexOf('.', index);
      if (endIndex == -1)
      {
        endIndex = index + subSentence.Length; // No succeeding period, go to last of sub-sentence
      }

      return text.Substring(startIndex, endIndex - startIndex).Trim();
    }
  }
}

