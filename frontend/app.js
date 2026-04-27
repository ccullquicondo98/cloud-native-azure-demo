const BACKEND_URL = "http://20.94.2.129";

// Health check
async function checkHealth() {
  try {
    const res = await fetch(`${BACKEND_URL}/health`);
    const data = await res.json();
    document.getElementById("healthOutput").innerText =
      JSON.stringify(data, null, 2);
  } catch (err) {
    document.getElementById("healthOutput").innerText =
      "Backend not reachable";
  }
}

// Load items from MySQL
async function loadItems() {
  const list = document.getElementById("itemsList");
  list.innerHTML = "";

  try {
    const res = await fetch(`${BACKEND_URL}/items`);
    const items = await res.json();

    items.forEach(item => {
      const li = document.createElement("li");
      li.innerText = `${item.id} - ${item.name}`;
      list.appendChild(li);
    });
  } catch (err) {
    const li = document.createElement("li");
    li.innerText = "Error loading items";
    list.appendChild(li);
  }
}

// Upload file
async function uploadFile() {
  const input = document.getElementById("fileInput");
  if (input.files.length === 0) {
    alert("Select a file first");
    return;
  }

  const formData = new FormData();
  formData.append("file", input.files[0]);

  const res = await fetch(`${BACKEND_URL}/files/upload`, {
    method: "POST",
    body: formData
  });

  const data = await res.json();
  document.getElementById("uploadOutput").innerText =
    JSON.stringify(data, null, 2);
}

// Download file
function downloadFile() {
  const filename = document.getElementById("downloadFileName").value;
  if (!filename) {
    alert("Enter a filename");
    return;
  }

  window.open(`${BACKEND_URL}/files/download/${filename}`, "_blank");
}
