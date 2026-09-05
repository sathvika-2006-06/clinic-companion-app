import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';
import '../../models/models.dart';
import '../../utils/colors.dart';

class CreateReferralScreen extends ConsumerStatefulWidget {
  const CreateReferralScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateReferralScreen> createState() =>
      _CreateReferralScreenState();
}

class _CreateReferralScreenState extends ConsumerState<CreateReferralScreen> {
  final _patientIdController = TextEditingController();
  final _chiefComplaintController = TextEditingController();
  final _clinicalFindingsController = TextEditingController();
  final _provisionalDiagnosisController = TextEditingController();
  final _treatmentPlannedController = TextEditingController();
  final _reasonController = TextEditingController();
  final _clinicalSummaryController = TextEditingController();

  String _selectedPriority = 'ROUTINE';
  DepartmentModel? _selectedDepartment;
  List<DepartmentModel> _departments = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    try {
      final apiService = ApiService();
      final departments = await apiService.getDepartments();
      setState(() => _departments = departments);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading departments: $e')),
        );
      }
    }
  }

  Future<void> _submitReferral() async {
    if (_patientIdController.text.isEmpty ||
        _chiefComplaintController.text.isEmpty ||
        _selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final apiService = ApiService();

      // Create case first
      final caseId = await apiService.createCase(
        patientId: _patientIdController.text,
        chiefComplaint: _chiefComplaintController.text,
        clinicalFindings: _clinicalFindingsController.text,
        provisionalDiagnosis: _provisionalDiagnosisController.text,
        treatmentPlanned: _treatmentPlannedController.text,
      );

      // Create referral
      final referralId = await apiService.createReferral(
        caseId: caseId,
        receivingDepartmentId: _selectedDepartment!.id,
        reasonForReferral: _reasonController.text,
        clinicalSummary: _clinicalSummaryController.text,
        priority: _selectedPriority,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Referral created successfully!')),
        );
        context.go('/student/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _patientIdController.dispose();
    _chiefComplaintController.dispose();
    _clinicalFindingsController.dispose();
    _provisionalDiagnosisController.dispose();
    _treatmentPlannedController.dispose();
    _reasonController.dispose();
    _clinicalSummaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Referral'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient ID
            const Text('Patient ID *', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _patientIdController,
              decoration: InputDecoration(
                hintText: 'e.g., P001',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Chief Complaint
            const Text('Chief Complaint *', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _chiefComplaintController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Describe the chief complaint',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Clinical Findings
            const Text('Clinical Findings', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _clinicalFindingsController,
              maxLines: 2,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Provisional Diagnosis
            const Text('Provisional Diagnosis', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _provisionalDiagnosisController,
              maxLines: 2,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Reason for Referral
            const Text('Reason for Referral', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 2,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Receiving Department
            const Text('Receiving Department *', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButton<DepartmentModel>(
              isExpanded: true,
              value: _selectedDepartment,
              hint: const Text('Select Department'),
              items: _departments.map((dept) {
                return DropdownMenuItem(
                  value: dept,
                  child: Text(dept.name),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedDepartment = value),
            ),
            const SizedBox(height: 16),

            // Priority
            const Text('Priority *', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: ['EMERGENCY', 'HIGH', 'ROUTINE'].map((priority) {
                Color color = AppColors.routine;
                if (priority == 'EMERGENCY') color = AppColors.emergency;
                if (priority == 'HIGH') color = AppColors.high;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedPriority == priority
                            ? color
                            : AppColors.gray200,
                      ),
                      onPressed: () => setState(() => _selectedPriority = priority),
                      child: Text(
                        priority,
                        style: TextStyle(
                          color: _selectedPriority == priority
                              ? AppColors.white
                              : AppColors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitReferral,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(AppColors.white),
                        ),
                      )
                    : const Text('Create Referral'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
