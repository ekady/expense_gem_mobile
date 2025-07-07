class Pagination {
  final int limit;
  final int page;
  final int total;
  final int totalPages;

  const Pagination({
    required this.limit,
    required this.page,
    required this.total,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      limit: json['limit'] ?? 0,
      page: json['page'] ?? 1,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
    );
  }

  bool get hasNextPage => page < totalPages;
  bool get hasPreviousPage => page > 1;
  int get nextPage => page + 1;
  int get previousPage => page - 1;
} 