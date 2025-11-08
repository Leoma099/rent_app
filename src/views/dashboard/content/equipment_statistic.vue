<template>
    <div class="card card-body shadow-sm border-0">
      <p class="mb-0">EQUIPMENT STATISTICS (DOUGHNUT)</p>
  
      <div class="mt-3">
        <canvas ref="doughnutChart" height="300"></canvas>
      </div>
    </div>
  </template>
  
  <script>
  import { Chart, registerables } from "chart.js";
  
  Chart.register(...registerables);
  
  export default {
    data() {
      return {
        doughnutChart: null,
      };
    },
    methods: {
      createDoughnutChart() {
        if (this.doughnutChart) {
          this.doughnutChart.destroy();
        }
  
        const data = {
          labels: [
            "Return Equipment",
            "Loss Equipment",
            "Available Equipment",
            "New Equipment Registered",
          ],
          datasets: [
            {
              label: "Equipment Status",
              data: [30, 15, 40, 15], // Example data values
              backgroundColor: ["#88bdf2", "#bdddfc", "#e1e3e2", "orange"],
            },
          ],
        };
  
        const options = {
          responsive: true,
          maintainAspectRatio: false,
          cutout: "70%",
          borderRadius: "5",
          plugins: {
            legend: {
              position: "bottom", // Legend positioned on the left
            },
          },
        };
  
        this.doughnutChart = new Chart(this.$refs.doughnutChart.getContext("2d"), {
          type: "doughnut",
          data: data,
          options: options,
        });
      },
    },
    mounted() {
      this.createDoughnutChart(); // Create chart on component load
    },
  };
  </script>
  
  <style>
  /* Optional: Add custom styles for your chart container */
  </style>
  