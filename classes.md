# Courson LMS — Kiến Trúc & Danh Sách Class Hệ Thống

Tài liệu này tổng hợp toàn bộ thông tin đặc tả hướng đối tượng (OOP) của dự án Courson LMS, bao gồm thuộc tính (fields) và phương thức (methods) theo từng package, đã loại bỏ toàn bộ dữ liệu hiển thị giao diện (diagram layout).

---

## 1. Package `controller` (Servlets)

### `AuthServlet`
* **Loại:** `«servlet»`
* **Kế thừa / Mapping:** `/auth/*`
* **Thuộc tính:**
  * `- MAPPING: String = "/auth/*" {static}`
  * `- authService: AuthService`
* **Phương thức:**
  * `+ init(): void`
  * `# doGet(req: HttpServletRequest, resp: HttpServletResponse): void`
  * `# doPost(req: HttpServletRequest, resp: HttpServletResponse): void`
  * `- processAction(action: String, req, resp): void`
  * `- showLogin(req, resp): void`
  * `- showRegister(req, resp): void`
  * `- login(req, resp): void`
  * `- register(req, resp): void`
  * `- logout(req, resp): void`
  * `- googleCallback(req, resp): void`
  * `- redirectByRole(user: UserDto, resp): void`

### `HomeServlet`
* **Loại:** `«servlet»`
* **Kế thừa / Mapping:** `/home`
* **Thuộc tính:**
  * `- MAPPING: String = "/home" {static}`
  * `- courseService: CourseService`
* **Phương thức:**
  * `+ init(): void`
  * `# doGet(req: HttpServletRequest, resp: HttpServletResponse): void`
  * `- showHome(req, resp): void`
  * `- searchCourses(req, resp): void`
  * `- forward(view: String, req, resp): void`

### `UserServlet`
* **Loại:** `«servlet»`
* **Kế thừa / Mapping:** `/users/*`
* **Thuộc tính:**
  * `- MAPPING: String = "/users/*" {static}`
  * `- userService: UserService`
* **Phương thức:**
  * `+ init(): void`
  * `# doGet(req, resp): void`
  * `# doPost(req, resp): void`
  * `- processAction(action: String, req, resp): void`
  * `- showList(req, resp): void`
  * `- showDetail(req, resp): void`
  * `- showProfile(req, resp): void`
  * `- saveUser(req, resp): void`
  * `- updateProfile(req, resp): void`
  * `- changeStatus(req, resp): void`
  * `- bindUser(req): UserDto`

### `SettingServlet`
* **Loại:** `«servlet»`
* **Kế thừa / Mapping:** `/settings/*`
* **Thuộc tính:**
  * `- MAPPING: String = "/settings/*" {static}`
  * `- settingService: SettingService`
* **Phương thức:**
  * `+ init(): void`
  * `# doGet(req, resp): void`
  * `# doPost(req, resp): void`
  * `- processAction(action: String, req, resp): void`
  * `- showList(req, resp): void`
  * `- showDetail(req, resp): void`
  * `- saveSetting(req, resp): void`
  * `- deleteSetting(req, resp): void`
  * `- bindSetting(req): SettingDto`

### `CourseServlet`
* **Loại:** `«servlet»`
* **Kế thừa / Mapping:** `/courses/*`
* **Thuộc tính:**
  * `- MAPPING: String = "/courses/*" {static}`
  * `- courseService: CourseService`
* **Phương thức:**
  * `+ init(): void`
  * `# doGet(req, resp): void`
  * `# doPost(req, resp): void`
  * `- processAction(action: String, req, resp): void`
  * `- showCatalog(req, resp): void`
  * `- showCourseDetail(req, resp): void`
  * `- showManagedCourses(req, resp): void`
  * `- saveCourse(req, resp): void`
  * `- deleteCourse(req, resp): void`
  * `- saveModule(req, resp): void`
  * `- deleteModule(req, resp): void`
  * `- saveLesson(req, resp): void`
  * `- deleteLesson(req, resp): void`
  * `- showLearningContent(req, resp): void`
  * `- updateLessonProgress(req, resp): void`
  * `- bindCourse(req): CourseDto`
  * `- bindModule(req): ModuleDto`
  * `- bindLesson(req): LessonDto`

### `RegistrationServlet`
* **Loại:** `«servlet»`
* **Kế thừa / Mapping:** `/registrations/*`
* **Thuộc tính:**
  * `- MAPPING: String = "/registrations/*" {static}`
  * `- registrationService: RegistrationService`
* **Phương thức:**
  * `+ init(): void`
  * `# doGet(req, resp): void`
  * `# doPost(req, resp): void`
  * `- processAction(action: String, req, resp): void`
  * `- showMyRegistrations(req, resp): void`
  * `- showCourseRegistrations(req, resp): void`
  * `- enroll(req, resp): void`
  * `- cancel(req, resp): void`
  * `- paymentReturn(req, resp): void`
  * `- paymentCallback(req, resp): void`
  * `- updateRegistrationStatus(req, resp): void`

### `QuizServlet`
* **Loại:** `«servlet»`
* **Kế thừa / Mapping:** `/quizzes/*`
* **Thuộc tính:**
  * `- MAPPING: String = "/quizzes/*" {static}`
  * `- quizService: QuizService`
* **Phương thức:**
  * `+ init(): void`
  * `# doGet(req, resp): void`
  * `# doPost(req, resp): void`
  * `- processAction(action: String, req, resp): void`
  * `- showQuizList(req, resp): void`
  * `- showQuizDetail(req, resp): void`
  * `- saveQuiz(req, resp): void`
  * `- deleteQuiz(req, resp): void`
  * `- showQuestionBank(req, resp): void`
  * `- showQuestionDetail(req, resp): void`
  * `- saveQuestion(req, resp): void`
  * `- deleteQuestion(req, resp): void`
  * `- assignQuestion(req, resp): void`
  * `- removeQuestion(req, resp): void`
  * `- reorderQuestions(req, resp): void`
  * `- showAttempt(req, resp): void`
  * `- submitAttempt(req, resp): void`
  * `- showResult(req, resp): void`
  * `- bindQuiz(req): QuizDto`
  * `- bindQuestion(req): QuestionDto`
  * `- bindAttempt(req): QuizAttemptDto`

---

## 2. Package `service`

### `AuthService`
* **Loại:** `«service»`
* **Thuộc tính:**
  * `- userDao: UserDao`
  * `- settingDao: SettingDao`
* **Phương thức:**
  * `+ AuthService(userDao: UserDao, settingDao: SettingDao)`
  * `+ authenticate(dto: LoginDto): UserDto`
  * `+ register(dto: RegisterDto): UserDto`
  * `+ authenticateGoogle(email: String, name: String): UserDto`
  * `+ logout(session: HttpSession): void`
  * `- validateLogin(dto: LoginDto): void`
  * `- validateRegistration(dto: RegisterDto): void`
  * `- resolveStudentRole(): Setting`
  * `- mapUser(user: User): UserDto`

### `UserService`
* **Loại:** `«service»`
* **Thuộc tính:**
  * `- userDao: UserDao`
  * `- settingDao: SettingDao`
* **Phương thức:**
  * `+ UserService(userDao: UserDao, settingDao: SettingDao)`
  * `+ getUsers(): List<UserDto>`
  * `+ getUser(userId: long): UserDto`
  * `+ saveUser(dto: UserDto): long`
  * `+ updateProfile(dto: UserDto): void`
  * `+ changeStatus(userId: long, status: UserStatus): void`
  * `- validateUser(dto: UserDto): void`
  * `- ensureUniqueIdentity(dto: UserDto): void`
  * `- mapUser(user: User): UserDto`

### `SettingService`
* **Loại:** `«service»`
* **Thuộc tính:**
  * `- settingDao: SettingDao`
* **Phương thức:**
  * `+ SettingService(settingDao: SettingDao)`
  * `+ getByType(type: SettingType): List<SettingDto>`
  * `+ getSetting(id: long): SettingDto`
  * `+ saveSetting(dto: SettingDto): long`
  * `+ deleteSetting(id: long): void`
  * `- validateSetting(dto: SettingDto): void`
  * `- preventReferencedDelete(id: long): void`
  * `- mapSetting(entity: Setting): SettingDto`

### `RegistrationService`
* **Loại:** `«service»`
* **Thuộc tính:**
  * `- registrationDao: RegistrationDao`
  * `- courseDao: CourseDao`
* **Phương thức:**
  * `+ RegistrationService(registrationDao, courseDao)`
  * `+ enroll(userId: long, courseId: long): RegistrationDto`
  * `+ getByUser(userId: long): List<RegistrationDto>`
  * `+ getByCourse(courseId: long): List<RegistrationDto>`
  * `+ updatePayment(id: long, status: PaymentStatus, code: String, paidAt: OffsetDateTime): void`
  * `+ cancel(id: long): void`
  * `+ refreshProgress(id: long): void`
  * `+ hasCourseAccess(userId: long, courseId: long): boolean`
  * `- initializePayment(course: Course): Registration`
  * `- validatePaymentTransition(current, next): void`
  * `- mapRegistration(entity: Registration): RegistrationDto`

### `CourseService`
* **Loại:** `«service»`
* **Thuộc tính:**
  * `- courseDao: CourseDao`
  * `- moduleDao: ModuleDao`
  * `- lessonDao: LessonDao`
  * `- lessonProgressDao: LessonProgressDao`
  * `- registrationDao: RegistrationDao`
* **Phương thức:**
  * `+ CourseService(courseDao, moduleDao, lessonDao, progressDao, registrationDao)`
  * `+ searchPublished(keyword: String, categoryId: Long): List<CourseDto>`
  * `+ getCourseDetail(courseId: long): CourseDto`
  * `+ getManagedCourses(userId: long): List<CourseDto>`
  * `+ saveCourse(dto: CourseDto): long`
  * `+ deleteCourse(courseId: long): void`
  * `+ saveModule(dto: ModuleDto): long`
  * `+ deleteModule(moduleId: long): void`
  * `+ saveLesson(dto: LessonDto): long`
  * `+ deleteLesson(lessonId: long): void`
  * `+ getLearningContent(registrationId: long): CourseDto`
  * `+ updateLessonProgress(registrationId: long, lessonId: long, status: LessonProgressStatus): void`
  * `- validateCourse(dto: CourseDto): void`
  * `- verifyCourseOwnership(courseId: long, userId: long): void`
  * `- buildCourseTree(course: Course): CourseDto`
  * `- refreshRegistrationProgress(registrationId: long): void`

### `QuizService`
* **Loại:** `«service»`
* **Thuộc tính:**
  * `- quizDao: QuizDao`
  * `- questionDao: QuestionDao`
  * `- quizAttemptDao: QuizAttemptDao`
  * `- registrationDao: RegistrationDao`
* **Phương thức:**
  * `+ QuizService(quizDao, questionDao, attemptDao, registrationDao)`
  * `+ getQuizzes(moduleId: long): List<QuizDto>`
  * `+ getQuizDetail(quizId: long): QuizDto`
  * `+ saveQuiz(dto: QuizDto): long`
  * `+ deleteQuiz(quizId: long): void`
  * `+ getQuestionBank(moduleId: long): List<QuestionDto>`
  * `+ getQuestion(questionId: long): QuestionDto`
  * `+ saveQuestion(dto: QuestionDto): long`
  * `+ deleteQuestion(questionId: long): void`
  * `+ assignQuestion(quizId: long, questionId: long, points: BigDecimal, order: int): void`
  * `+ removeQuestion(quizId: long, questionId: long): void`
  * `+ reorderQuestions(quizId: long, orderedIds: List<Long>): void`
  * `+ startAttempt(registrationId: long, quizId: long): QuizAttemptDto`
  * `+ submitAttempt(dto: QuizAttemptDto): QuizResultDto`
  * `+ getResult(registrationId: long, quizId: long): QuizResultDto`
  * `- validateQuestion(dto: QuestionDto): void`
  * `- ensureSameModule(quizId: long, questionId: long): void`
  * `- gradeAnswer(question, submitted): QuizAnswer`
  * `- calculateResult(attempt, answers): QuizResultDto`
  * `- saveAttemptTransaction(attempt, answers): void`

---

## 3. Package `dao` (Data Access Objects)

### `SettingDao`
* **Loại:** `«dao»`
* **Thuộc tính:**
  * `- SQL_*: String {static}`
* **Phương thức:**
  * `+ findByType(con: Connection, type: SettingType): List<Setting>`
  * `+ findById(con: Connection, id: long): Optional<Setting>`
  * `+ insert(con: Connection, entity: Setting): long`
  * `+ update(con: Connection, entity: Setting): boolean`
  * `+ delete(con: Connection, id: long): boolean`
  * `- mapRow(rs: ResultSet): Setting`

### `UserDao`
* **Loại:** `«dao»`
* **Thuộc tính:**
  * `- SQL_*: String {static}`
* **Phương thức:**
  * `+ findAll(con: Connection): List<User>`
  * `+ findById(con: Connection, id: long): Optional<User>`
  * `+ findByUsernameOrEmail(con: Connection, value: String): Optional<User>`
  * `+ existsUsername(con, username: String, excludeId: Long): boolean`
  * `+ existsEmail(con, email: String, excludeId: Long): boolean`
  * `+ insert(con: Connection, entity: User): long`
  * `+ update(con: Connection, entity: User): boolean`
  * `+ updateStatus(con: Connection, id: long, status: UserStatus): boolean`
  * `- mapRow(rs: ResultSet): User`

### `CourseDao`
* **Loại:** `«dao»`
* **Thuộc tính:**
  * `- SQL_*: String {static}`
* **Phương thức:**
  * `+ searchPublished(con, keyword: String, categoryId: Long): List<Course>`
  * `+ findById(con: Connection, id: long): Optional<Course>`
  * `+ findByManagerOrExpert(con, userId: long): List<Course>`
  * `+ insert(con: Connection, entity: Course): long`
  * `+ update(con: Connection, entity: Course): boolean`
  * `+ delete(con: Connection, id: long): boolean`
  * `- mapRow(rs: ResultSet): Course`

### `ModuleDao`
* **Loại:** `«dao»`
* **Thuộc tính:**
  * `- SQL_*: String {static}`
* **Phương thức:**
  * `+ findByCourseId(con: Connection, courseId: long): List<Module>`
  * `+ findById(con: Connection, id: long): Optional<Module>`
  * `+ existsOrderIndex(con, courseId: long, order: int, excludeId: Long): boolean`
  * `+ insert(con: Connection, entity: Module): long`
  * `+ update(con: Connection, entity: Module): boolean`
  * `+ delete(con: Connection, id: long): boolean`
  * `- mapRow(rs: ResultSet): Module`

### `LessonDao`
* **Loại:** `«dao»`
* **Thuộc tính:**
  * `- SQL_*: String {static}`
* **Phương thức:**
  * `+ findByModuleId(con: Connection, moduleId: long): List<Lesson>`
  * `+ findById(con: Connection, id: long): Optional<Lesson>`
  * `+ existsOrderIndex(con, moduleId: long, order: int, excludeId: Long): boolean`
  * `+ insert(con: Connection, entity: Lesson): long`
  * `+ update(con: Connection, entity: Lesson): boolean`
  * `+ delete(con: Connection, id: long): boolean`
  * `- mapRow(rs: ResultSet): Lesson`

### `RegistrationDao`
* **Loại:** `«dao»`
* **Thuộc tính:**
  * `- SQL_*: String {static}`
* **Phương thức:**
  * `+ findById(con: Connection, id: long): Optional<Registration>`
  * `+ findByUserId(con: Connection, userId: long): List<Registration>`
  * `+ findByCourseId(con: Connection, courseId: long): List<Registration>`
  * `+ findByUserAndCourse(con, userId: long, courseId: long): Optional<Registration>`
  * `+ findByPaymentCode(con, code: String): Optional<Registration>`
  * `+ insert(con: Connection, entity: Registration): long`
  * `+ updatePayment(con: Connection, entity: Registration): boolean`
  * `+ updateProgress(con: Connection, id: long, percent: BigDecimal): boolean`
  * `+ updateStatus(con: Connection, id: long, status: RegistrationStatus): boolean`
  * `- mapRow(rs: ResultSet): Registration`

### `LessonProgressDao`
* **Loại:** `«dao»`
* **Thuộc tính:**
  * `- SQL_*: String {static}`
* **Phương thức:**
  * `+ findByRegistrationId(con, registrationId: long): List<LessonProgress>`
  * `+ findByRegistrationAndLesson(con, registrationId: long, lessonId: long): Optional<LessonProgress>`
  * `+ upsert(con: Connection, entity: LessonProgress): long`
  * `+ calculateProgress(con: Connection, registrationId: long): BigDecimal`
  * `- mapRow(rs: ResultSet): LessonProgress`

### `QuizDao`
* **Loại:** `«dao»`
* **Thuộc tính:**
  * `- SQL_*: String {static}`
* **Phương thức:**
  * `+ findByModuleId(con: Connection, moduleId: long): List<Quiz>`
  * `+ findById(con: Connection, id: long): Optional<Quiz>`
  * `+ existsOrderIndex(con, moduleId: long, order: int, excludeId: Long): boolean`
  * `+ insert(con: Connection, entity: Quiz): long`
  * `+ update(con: Connection, entity: Quiz): boolean`
  * `+ delete(con: Connection, id: long): boolean`
  * `+ findAssignments(con: Connection, quizId: long): List<QuizQuestion>`
  * `+ saveAssignment(con: Connection, item: QuizQuestion): long`
  * `+ deleteAssignment(con, quizId: long, questionId: long): boolean`
  * `+ reorderAssignments(con, quizId: long, items: List<QuizQuestion>): void`
  * `- mapQuiz(rs: ResultSet): Quiz`
  * `- mapAssignment(rs: ResultSet): QuizQuestion`

### `QuestionDao`
* **Loại:** `«dao»`
* **Thuộc tính:**
  * `- SQL_*: String {static}`
* **Phương thức:**
  * `+ findByModuleId(con: Connection, moduleId: long): List<Question>`
  * `+ findById(con: Connection, id: long): Optional<Question>`
  * `+ insert(con: Connection, entity: Question): long`
  * `+ update(con: Connection, entity: Question): boolean`
  * `+ delete(con: Connection, id: long): boolean`
  * `+ findOptions(con: Connection, questionId: long): List<AnswerOption>`
  * `+ replaceOptions(con, questionId: long, options: List<AnswerOption>): void`
  * `- insertOption(con: Connection, option: AnswerOption): long`
  * `- mapQuestion(rs: ResultSet): Question`
  * `- mapOption(rs: ResultSet): AnswerOption`

### `QuizAttemptDao`
* **Loại:** `«dao»`
* **Thuộc tính:**
  * `- SQL_*: String {static}`
* **Phương thức:**
  * `+ findByRegistrationAndQuiz(con, registrationId: long, quizId: long): Optional<QuizAttempt>`
  * `+ findAnswers(con: Connection, attemptId: long): List<QuizAnswer>`
  * `+ upsertAttempt(con: Connection, entity: QuizAttempt): long`
  * `+ replaceAnswers(con: Connection, attemptId: long, answers: List<QuizAnswer>): void`
  * `- insertAnswer(con: Connection, answer: QuizAnswer): long`
  * `- mapAttempt(rs: ResultSet): QuizAttempt`
  * `- mapAnswer(rs: ResultSet): QuizAnswer`

---

## 4. Package `filter` & `util`

### `AuthenticationFilter`
* **Loại:** `«filter»`
* **Thuộc tính:**
  * `- publicPaths: Set<String>`
* **Phương thức:**
  * `+ init(config: FilterConfig): void`
  * `+ doFilter(request: ServletRequest, response: ServletResponse, chain: FilterChain): void`
  * `+ destroy(): void`
  * `- isPublicPath(path: String): boolean`
  * `- redirectToLogin(req, resp): void`

### `AuthorizationFilter`
* **Loại:** `«filter»`
* **Thuộc tính:**
  * `- routeRoles: Map<String, Set<String>>`
* **Phương thức:**
  * `+ init(config: FilterConfig): void`
  * `+ doFilter(request: ServletRequest, response: ServletResponse, chain: FilterChain): void`
  * `+ destroy(): void`
  * `- requiredRoles(path: String): Set<String>`
  * `- hasPermission(role: String, required: Set<String>): boolean`
  * `- sendForbidden(resp): void`

### `EncodingFilter`
* **Loại:** `«filter»`
* **Thuộc tính:**
  * `- encoding: String = "UTF-8"`
* **Phương thức:**
  * `+ init(config: FilterConfig): void`
  * `+ doFilter(request: ServletRequest, response: ServletResponse, chain: FilterChain): void`
  * `+ destroy(): void`

### `DbConnection`
* **Loại:** `«utility»`
* **Thuộc tính:**
  * `- URL: String {static}`
  * `- USER: String {static}`
  * `- PASSWORD: String {static}`
* **Phương thức:**
  * `- DbConnection()`
  * `+ getConnection(): Connection {static}`
  * `+ rollbackQuietly(con: Connection): void {static}`
  * `+ closeQuietly(resource: AutoCloseable): void {static}`

### `PasswordUtil`
* **Loại:** `«utility»`
* **Thuộc tính:**
  * `- WORK_FACTOR: int {static}`
* **Phương thức:**
  * `- PasswordUtil()`
  * `+ hash(rawPassword: String): String {static}`
  * `+ verify(rawPassword: String, passwordHash: String): boolean {static}`

### `ValidationUtil`
* **Loại:** `«utility»`
* **Phương thức:**
  * `- ValidationUtil()`
  * `+ requireText(value: String, field: String): void {static}`
  * `+ requirePositive(value: BigDecimal, field: String): void {static}`
  * `+ requireRange(value: BigDecimal, min, max, field): void {static}`
  * `+ isEmail(value: String): boolean {static}`
  * `+ parseLong(value: String, field: String): long {static}`
  * `+ parseInteger(value: String, field: String): int {static}`

### `SessionUtil`
* **Loại:** `«utility»`
* **Thuộc tính:**
  * `- CURRENT_USER: String {static}`
* **Phương thức:**
  * `- SessionUtil()`
  * `+ setCurrentUser(req: HttpServletRequest, user: UserDto): void {static}`
  * `+ getCurrentUser(req: HttpServletRequest): UserDto {static}`
  * `+ getCurrentUserId(req: HttpServletRequest): Long {static}`
  * `+ getCurrentRole(req: HttpServletRequest): String {static}`
  * `+ invalidate(req: HttpServletRequest): void {static}`

---

## 5. Package `dto`

Mỗi DTO đều có constructor mặc định, constructor nhận tất cả tham số, cùng các cặp getter/setter tương ứng.

### `LoginDto`
* `+ loginId: String`
* `+ password: String`
* `+ rememberMe: boolean`

### `RegisterDto`
* `+ username: String`
* `+ email: String`
* `+ password: String`
* `+ confirmPassword: String`
* `+ fullName: String`

### `UserDto`
* `+ id: Long`
* `+ username: String`
* `+ email: String`
* `+ fullName: String`
* `+ roleId: Long`
* `+ roleName: String`
* `+ authProvider: AuthProvider`
* `+ status: UserStatus`

### `SettingDto`
* `+ id: Long`
* `+ type: SettingType`
* `+ name: String`
* `+ value: String`
* `+ priority: int`
* `+ status: SettingStatus`
* `+ description: String`

### `CourseDto`
* `+ id: Long`
* `+ title: String`
* `+ categoryId: Long`
* `+ categoryName: String`
* `+ description: String`
* `+ price: BigDecimal`
* `+ status: CourseStatus`
* `+ managerName: String`
* `+ expertName: String`
* `+ modules: List<ModuleDto>`

### `ModuleDto`
* `+ id: Long`
* `+ courseId: Long`
* `+ title: String`
* `+ orderIndex: int`
* `+ lessons: List<LessonDto>`
* `+ quizzes: List<QuizDto>`

### `LessonDto`
* `+ id: Long`
* `+ moduleId: Long`
* `+ title: String`
* `+ content: String`
* `+ videoUrl: String`
* `+ documentUrl: String`
* `+ orderIndex: int`
* `+ progressStatus: LessonProgressStatus`

### `RegistrationDto`
* `+ id: Long`
* `+ userId: Long`
* `+ userName: String`
* `+ courseId: Long`
* `+ courseTitle: String`
* `+ registrationDate: OffsetDateTime`
* `+ progressPercentage: BigDecimal`
* `+ status: RegistrationStatus`
* `+ paymentMethod: PaymentMethod`
* `+ paymentCode: String`
* `+ paymentAmount: BigDecimal`
* `+ paymentStatus: PaymentStatus`
* `+ paidAt: OffsetDateTime`

### `LessonProgressDto`
* `+ id: Long`
* `+ registrationId: Long`
* `+ lessonId: Long`
* `+ status: LessonProgressStatus`
* `+ completedAt: OffsetDateTime`

### `QuizDto`
* `+ id: Long`
* `+ moduleId: Long`
* `+ title: String`
* `+ passScore: BigDecimal`
* `+ timeLimitMinutes: Integer`
* `+ orderIndex: int`
* `+ questions: List<QuestionDto>`

### `QuestionDto`
* `+ id: Long`
* `+ moduleId: Long`
* `+ questionText: String`
* `+ questionType: QuestionType`
* `+ defaultPoints: BigDecimal`
* `+ assignedPoints: BigDecimal`
* `+ quizOrderIndex: Integer`
* `+ options: List<AnswerOptionDto>`

### `AnswerOptionDto`
* `+ id: Long`
* `+ questionId: Long`
* `+ optionText: String`
* `+ correct: boolean`
* `+ orderIndex: int`

### `QuizAnswerDto`
* `+ questionId: Long`
* `+ selectedOptionId: Long`
* `+ correct: boolean`
* `+ score: BigDecimal`

### `QuizAttemptDto`
* `+ id: Long`
* `+ registrationId: Long`
* `+ quizId: Long`
* `+ submittedAt: OffsetDateTime`
* `+ totalScore: BigDecimal`
* `+ passStatus: boolean`
* `+ answers: List<QuizAnswerDto>`

### `QuizResultDto`
* `+ quizTitle: String`
* `+ totalScore: BigDecimal`
* `+ maxScore: BigDecimal`
* `+ percentage: BigDecimal`
* `+ passStatus: boolean`
* `+ answers: List<QuizAnswerDto>`

---

## 6. Package `entity`

Mỗi Entity có constructor mặc định, constructor nhận tất cả tham số, cùng các cặp getter/setter cho toàn bộ các trường.

### `Setting`
* `+ id: Long`
* `+ type: SettingType`
* `+ name: String`
* `+ value: String`
* `+ priority: int`
* `+ status: SettingStatus`
* `+ description: String`
* `+ createdAt: OffsetDateTime`
* `+ updatedAt: OffsetDateTime`

### `User`
* `+ id: Long`
* `+ username: String`
* `+ email: String`
* `+ passwordHash: String`
* `+ fullName: String`
* `+ roleId: Long`
* `+ roleType: SettingType`
* `+ authProvider: AuthProvider`
* `+ status: UserStatus`
* `+ createdAt: OffsetDateTime`
* `+ updatedAt: OffsetDateTime`

### `Course`
* `+ id: Long`
* `+ title: String`
* `+ categoryId: Long`
* `+ categoryType: SettingType`
* `+ description: String`
* `+ price: BigDecimal`
* `+ status: CourseStatus`
* `+ managerId: Long`
* `+ expertId: Long`
* `+ createdAt: OffsetDateTime`
* `+ updatedAt: OffsetDateTime`

### `Module`
* `+ id: Long`
* `+ courseId: Long`
* `+ title: String`
* `+ orderIndex: int`
* `+ createdAt: OffsetDateTime`

### `Lesson`
* `+ id: Long`
* `+ moduleId: Long`
* `+ title: String`
* `+ content: String`
* `+ videoUrl: String`
* `+ documentUrl: String`
* `+ orderIndex: int`
* `+ createdAt: OffsetDateTime`
* `+ updatedAt: OffsetDateTime`

### `Quiz`
* `+ id: Long`
* `+ moduleId: Long`
* `+ title: String`
* `+ passScore: BigDecimal`
* `+ timeLimitMinutes: Integer`
* `+ orderIndex: int`
* `+ createdAt: OffsetDateTime`
* `+ updatedAt: OffsetDateTime`

### `Question`
* `+ id: Long`
* `+ moduleId: Long`
* `+ questionText: String`
* `+ questionType: QuestionType`
* `+ defaultPoints: BigDecimal`
* `+ createdAt: OffsetDateTime`

### `QuizQuestion`
* `+ id: Long`
* `+ quizId: Long`
* `+ questionId: Long`
* `+ moduleId: Long`
* `+ orderIndex: int`
* `+ points: BigDecimal`

### `AnswerOption`
* `+ id: Long`
* `+ questionId: Long`
* `+ optionText: String`
* `+ correct: boolean`
* `+ orderIndex: int`

### `Registration`
* `+ id: Long`
* `+ userId: Long`
* `+ courseId: Long`
* `+ registrationDate: OffsetDateTime`
* `+ progressPercentage: BigDecimal`
* `+ status: RegistrationStatus`
* `+ paymentMethod: PaymentMethod`
* `+ paymentCode: String`
* `+ paymentAmount: BigDecimal`
* `+ paymentStatus: PaymentStatus`
* `+ paidAt: OffsetDateTime`

### `LessonProgress`
* `+ id: Long`
* `+ registrationId: Long`
* `+ lessonId: Long`
* `+ status: LessonProgressStatus`
* `+ completedAt: OffsetDateTime`

### `QuizAttempt`
* `+ id: Long`
* `+ registrationId: Long`
* `+ quizId: Long`
* `+ submittedAt: OffsetDateTime`
* `+ totalScore: BigDecimal`
* `+ passStatus: boolean`

### `QuizAnswer`
* `+ id: Long`
* `+ quizAttemptId: Long`
* `+ questionId: Long`
* `+ selectedOptionId: Long`
* `+ correct: boolean`
* `+ score: BigDecimal`

---

## 7. Package `entity.enums` (Enumerations)

Mỗi enum đều có phương thức:
* `+ getDbValue(): String`
* `+ fromDb(value: String): [EnumType] {static}`

### `SettingType`
* `USER_ROLE`
* `COURSE_CATEGORY`

### `SettingStatus`
* `ACTIVE`
* `INACTIVE`

### `AuthProvider`
* `LOCAL`
* `GOOGLE`

### `UserStatus`
* `ACTIVE`
* `INACTIVE`
* `BANNED`

### `CourseStatus`
* `DRAFT`
* `PUBLISHED`
* `ARCHIVED`

### `QuestionType`
* `SINGLE_CHOICE`
* `MULTI_CHOICE`
* `TRUE_FALSE`

### `RegistrationStatus`
* `PENDING`
* `ACTIVE`
* `COMPLETED`
* `CANCELLED`

### `PaymentMethod`
* `SEPAY`
* `VNPAY`

### `PaymentStatus`
* `FREE`
* `PENDING`
* `SUCCESS`
* `FAILED`

### `LessonProgressStatus`
* `NOT_STARTED`
* `IN_PROGRESS`
* `COMPLETED`