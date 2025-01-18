using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using mcMath;

namespace ExampleDesktop
{
    public partial class Form1 : Form
    {
        private TextBox textBox1;
        private TextBox textBox2;
        private Button calculateButton;
        private Label resultLabel;
        private Label plusLabel;

        public Form1()
        {
            InitializeComponent();
            InitializeCustomComponents();
        }

        private void InitializeCustomComponents()
        {
            // TextBox for first number
            textBox1 = new TextBox();
            textBox1.Location = new System.Drawing.Point(50, 30);
            this.Controls.Add(textBox1);

            // Label for plus symbol
            plusLabel = new Label();
            plusLabel.Text = "+";
            plusLabel.Location = new System.Drawing.Point(40, 55);
            plusLabel.AutoSize = true;
            this.Controls.Add(plusLabel);

            // TextBox for second number
            textBox2 = new TextBox();
            textBox2.Location = new System.Drawing.Point(50, 70);
            this.Controls.Add(textBox2);

            // Button to perform calculation
            calculateButton = new Button();
            calculateButton.Text = "Calculate";
            calculateButton.Location = new System.Drawing.Point(50, 110);
            calculateButton.Click += new EventHandler(CalculateButton_Click);
            this.Controls.Add(calculateButton);

            // Label to display result
            resultLabel = new Label();
            resultLabel.Location = new System.Drawing.Point(50, 150);
            resultLabel.AutoSize = true;
            this.Controls.Add(resultLabel);
        }

        private void CalculateButton_Click(object sender, EventArgs e)
        {
            if (long.TryParse(textBox1.Text, out long num1) && long.TryParse(textBox2.Text, out long num2))
            {
                mcMathComp cls = new mcMathComp();
                long result = cls.Add(num1, num2);
                cls.Extra = false;
                resultLabel.Text = $"Result: {result}";
            }
            else
            {
                resultLabel.Text = "Please enter valid numbers.";
            }
        }
    }
}
