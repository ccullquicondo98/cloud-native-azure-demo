const BACKEND_URL = "http://20.94.2.129";

// -------------------------
// Health check
// -------------------------
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

// -------------------------
// Load items from MySQL
// -------------------------
async function loadItems() {
  const list = document.getElementById("itemsList");
  list.innerHTML = "";

  try {
    const res = await fetch(`${BACKEND_URL}/items`);

    if (!res.ok) {
      throw new Error("Error loading items");
    }

    const items = await res.json();

    if (items.length === 0) {
      const li = document.createElement("li");
      li.innerText = "No items found";
      list.appendChild(li);
      return;
    }

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

// -------------------------
// Create new item
// -------------------------
async function createItem() {
  const input = document.getElementById("itemName");
  const output = document.getElementById("itemOutput");

  const itemName = input.value.trim();

  if (!itemName) {
    alert("Enter an item name");
    return;
  }

  try {
    const res = await fetch(
      `${BACKEND_URL}/items?name=${encodeURIComponent(itemName)}`,
      {
        method: "POST"
      }
    );

    const data = await res.json();

    if (!res.ok) {
      throw new Error(data.detail || "Error creating item");
    }

    output.innerText = JSON.stringify(data, null, 2);

    // limpiar input
    input.value = "";

    // recargar lista automáticamente
    loadItems();

  } catch (err) {
    output.innerText = `Error: ${err.message}`;
  }
}

// -------------------------
// Upload file to Blob Storage
// -------------------------
async function uploadFile() {
  const input = document.getElementById("fileInput");
  const output = document.getElementById("uploadOutput");

  if (input.files.length === 0) {
    alert("Select a file first");
    return;
  }

  try {
    const formData = new FormData();
    formData.append("file", input.files[0]);

    const res = await fetch(`${BACKEND_URL}/files/upload`, {
      method: "POST",
      body: formData
    });

    const data = await res.json();

    if (!res.ok) {
      throw new Error(data.detail || "Upload failed");
    }

    output.innerText = JSON.stringify(data, null, 2);

    // limpiar selector
    input.value = "";

  } catch (err) {
    output.innerText = `Error: ${err.message}`;
  }
}

// -------------------------
// Download file from Blob Storage
// -------------------------
function downloadFile() {
  const filename = document.getElementById("downloadFileName").value.trim();

  if (!filename) {
    alert("Enter a filename");
    return;
  }

  window.open(
    `${BACKEND_URL}/files/download/${encodeURIComponent(filename)}`,
    "_blank"
  );
}

// -------------------------
// Auto load items on page load
// -------------------------
window.onload = () => {
  checkHealth();
  loadItems();
};