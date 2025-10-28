# TODO: Integrate News API with Home Page Pagination

## 1. Update API Endpoints
- Add news API URL to `lib/services/api_endpoints.dart`

## 2. Create News Service
- Create `lib/services/news_service.dart` to handle API calls with pagination

## 3. Update News Model
- Update `lib/modules/read/model/news_model.dart` to match API response fields (title, description, image_url, pubDate, etc.)

## 4. Create Home Controller
- Create `lib/modules/home/controller/home_controller.dart` for state management (news list, loading, pagination)

## 5. Update Home Page
- Modify `lib/modules/home/home_page.dart` to use controller
- Replace hardcoded newsCards with dynamic list from API
- Implement infinite scroll or pagination to load 15 news at a time

## 6. Test Integration
- Run app and verify news loading and pagination
