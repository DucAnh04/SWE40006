using Microsoft.AspNetCore.Mvc;

namespace Task3._2.Controllers
{
    public class CalculatorController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Calculate(double num1, double num2, string operation)
        {
            double result = 0;

            switch (operation)
            {
                case "Add":
                    result = num1 + num2;
                    break;
                case "Subtract":
                    result = num1 - num2;
                    break;
                case "Multiply":
                    result = num1 * num2;
                    break;
                case "Divide":
                    result = num2 != 0 ? num1 / num2 : double.NaN; // Prevent division by zero
                    break;
            }

            ViewBag.Result = result;
            return View("Index");
        }
    }
}
