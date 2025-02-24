#  Recipe List

### Summary

The Recipe List iOS App is a SwiftUI-based mobile application that fetches and displays a list of recipes from a network source. The app allows users to view recipe names, cuisines, and images. It handles different states such as loading, empty, error, and successfully loaded recipes. The app also supports image caching for efficiency, especially when dealing with large images and limited network bandwidth.

### Features:

1. **Dynamic Recipe Fetching:** Recipes are fetched from the given API, and the UI updates accordingly to show the loading state, error messages, or empty state if no recipes are found. User can refresh the list anytime using pull-to-refresh.
2. **Image Caching:** Images of recipes are fetched from URLs and cached locally for quicker subsequent access.
3. **Error Handling:** Includes error states for network issues, empty content, and loading issues.
4. **Dependency Injection:** The app uses dependency injection to manage services like network manager and image loading, making the app scalable and testable.

<table>
  <tr>
    <th><strong>Light Mode</strong></th>
    <th><strong>Dark Mode</strong></th>
    <th><strong>Error Response</strong></th>
    <th><strong>Empty Response</strong></th>
  </tr>
  <tr>
    <td valign="top"><img src="https://github.com/user-attachments/assets/9fb50fd0-cd51-4f05-b6b6-7a5443034630" width="480" /></td>
    <td valign="top"><img src="https://github.com/user-attachments/assets/87f1f5a7-7375-4967-bbe8-e4fdf8639481" width="480" /></td>
    <td valign="top"><img src="https://github.com/user-attachments/assets/258f916a-b794-4edd-b592-e2b4dfc0175e" width="480" /></td>
    <td valign="top"><img src="https://github.com/user-attachments/assets/2ae2b696-62e7-4434-acb5-37c4a82cc545" width="480" /></td>
  </tr>
</table>

### Focus Areas

For this app, I prioritized the following areas:

1. **Network Handling and Error Management:** Ensuring the app handles network issues gracefully, such as displaying loading indicators, retrying failed requests, and showing relevant error messages.

2. **Image Caching:** This was a key feature to enhance performance, as images can be large. Caching images locally ensures the app remains responsive even after initial load.

3. **Dependency Injection:** I wanted to ensure that the app is scalable and testable, so I used dependency injection to inject services like RecipeService and ImageManager.

4. **State Management with SwiftUI:** I focused on managing app states such as loading, loaded, and error using `@Published` variables and the `ViewState` enum to create a smooth user experience.

I chose to focus on these areas because they directly contribute to the app’s user experience and maintainability. The handling of dynamic data and performance optimization through image caching were particularly important given the potential size and quantity of data the app may handle in future.

### Time Spent:

Total Time: Approximately 6 hours.

Time Breakdown:

- Initial Planning & Design: (1 hour) – Deciding on app features and setting up the structure.
- Network Layer & Recipe Fetching: (30 mins) – Implementing network requests to fetch recipes and handle errors.
- Image Caching Implementation: (2 hours) – Setting up caching and image loading mechanisms.
- UI Development: (1 hour) – Building the views with List, handling states, and displaying data.
- Testing & Debugging: (1 hour) – Testing the app, fixing bugs, and ensuring smooth performance.
- ReadMe and Documentation: (1 hour) – Writing the README and adding necessary comments.

### Trade-offs and Decisions:

1. **Image Caching vs. Memory Usage:** A decision was made to cache images locally using the file system to improve performance. However, this could potentially increase memory usage if not managed properly. I had to balance between keeping images in memory or storing them locally. I chose a local cache in the app's cache directory.

2. **Error Handling and Retry Logic:** Rather than focusing on making every network call fully resilient with retries, I opted for a simpler error state and retry mechanism that focuses on presenting an error message and providing the option to retry fetching the data.

3. **Data Model & API Structure:** I abstracted the network layer with a RecipeService protocol and a NetworkManager implementation. This allows flexibility for switching network implementations or mocking for testing.

### Weakest Part of the Project

The weakest part of the project might be error handling. While errors are displayed to the user, more advanced handling could have been implemented. For instance:

- **Specific Error Messages:** Currently, error messages are generic. More specific error handling (e.g., differentiating between no internet connection or server issues) could provide a better user experience.

- **Caching Strategy:** The image caching solution is quite basic. There could be improvements in terms of cache size management and cache invalidation strategies to ensure better memory and disk usage over time. App currently clears the cache when memory warning notification is recieved.

### Additional Information:

Insights:

- SwiftUI's Declarative UI: Using `@Published` for state management and SwiftUI's declarative style allowed me to quickly build the UI and handle various states (loading, error, etc.) effectively.
- Swift Concurrency: Async/await (async throws) was leveraged for network calls, providing a simple and readable way to handle asynchronous operations in Swift.

Constraints:

**Limited Time:** Due to time constraints, I focused on building the essential functionality and ensuring the app was user-friendly and stable. Features like advanced caching and more detailed error recovery could be added in the future.

