<template>
    <div class="card card-body shadow-sm border-0">
      <div class="d-flex justify-content-between align-items-">
        <p class="mb-0">BORROWER STATISTIC</p>
        <div>
          <select class="form-select" v-model="timeFrame">
            <option value="daily">Daily</option>
            <option value="weekly">Weekly</option>
            <option value="monthly">Monthly</option>
          </select>
        </div>
      </div>
      <div class="mt-3">
        <canvas ref="lineReport" height="300"></canvas>
      </div>
    </div>
  </template>
  
  <script>
  import { Chart, registerables } from "chart.js";
  
  Chart.register(...registerables);
  
  export default {
    data() {
      return {
        timeFrame: "daily", // Default value
        myChart: null,
      };
    },
    methods: {
      generateData() {
        let labels = [];
        let data = [];
  
        if (this.timeFrame === "daily") {
          labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
          data = [5, 10, 12, 7, 15, 8, 20];
        } else if (this.timeFrame === "weekly") {
          labels = ["Week 1", "Week 2", "Week 3", "Week 4"];
          data = [30, 50, 40, 60];
        } else if (this.timeFrame === "monthly") {
          labels = ["Jan", "Feb", "Mar"];
          data = [150, 200, 180];
        }
  
        this.createChart(labels, data);
      },
  
      createChart(labels, values) {
        if (this.myChart) {
          this.myChart.destroy();
        }
  
        this.myChart = new Chart(this.$refs.lineReport.getContext("2d"), {
          type: "bar",
          data: {
            labels: labels,
            datasets: [
              {
                label: "Borrower",
                data: values.map((v) => v * 0.25), // Example transformation
                fill: false,
                backgroundColor: "#e1e3e2",
                tension: 0.1,
              },
              {
                label: "Returned",
                data: values.map((v) => v * 0.35),
                fill: false,
                backgroundColor: "#88bdf2",
                tension: 0.1,
              },
              {
                label: "Loss",
                data: values.map((v) => v * 0.2),
                fill: false,
                backgroundColor: "#bdddfc",
                tension: 0.1,
              },
            ],
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins:
            {
                legend:
                {
                    position: "bottom",
                    // labels:
                    // {
                    //     usePointStyle: true,
                    // },
                }
            },
            scales: {
              y: {
                title: {
                  display: true,
                  text: "Number of Requests",
                },
                beginAtZero: true,
              },
            },
          },
        });
      },
    },
    watch: {
      timeFrame() {
        this.generateData();
      },
    },
    mounted() {
      this.generateData(); // Generate initial chart
    },
  };
  </script>
  
  <style>
  /* Add styling as necessary */
  </style>
  