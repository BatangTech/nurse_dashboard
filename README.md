<h1>🚀 How to Run Flutter Web</h1>

<h2>📱 Frontend (Flutter Web)</h2>

<ol>
  <li>Install dependencies</li>
</ol>

<pre><code>
flutter pub get
</code></pre>

<ol start="2">
  <li>Set up Firebase</li>
  <p>Download your <code>google-services.json</code> file from Firebase Console and place it inside the <code>web/</code> directory.</p>
</ol>

<ol start="3">
  <li>Enable Flutter web support (if not enabled)</li>
</ol>

<pre><code>
flutter config --enable-web
</code></pre>

<ol start="4">
  <li>Run the app on a web browser</li>
</ol>

<pre><code>
flutter run -d chrome
</code></pre>

<ol start="5">
  <li>Build for web deployment</li>
</ol>

<pre><code>
flutter build web
</code></pre>

<ol start="6">
  <li>Serve the built web app locally (optional)</li>
</ol>

<pre><code>
flutter serve
</code></pre>

