-- ������� ����� 2
SELECT DISTINCT CAST(���� AS date) AS ����
FROM �������

--������� ����� 3
SELECT DISTINCT ���������� AS ����������
FROM �������
ORDER BY ����������

--������� ����� 4
SELECT DISTINCT ����� AS �����
FROM �������
WHERE ���� > 100

--������� ����� 5
SELECT DISTINCT ���������� AS ����������
FROM �������
WHERE (CAST('2025-09-08' AS date) <= ����) AND (���� <= CAST('2025-09-15' AS date))

--������� ����� 6
SELECT *, ����� * ���� AS ���������
FROM �������

--������� ����� 7
SELECT *
FROM �������
WHERE (CAST('2025-01-01' AS date) <= ����) AND (���� <= CAST('2025-02-01' AS date)) AND ((LEFT(����������, 1) = '�') OR (���� < 10 AND ����� > 5))
ORDER BY ����, ���� desc

--������� ����� 8
SELECT DISTINCT top 5 ���������� AS ����������
FROM �������
WHERE (CAST('2024-09-01' AS date) <= ����) AND (���� <= CAST('2024-10-01' AS date))
ORDER BY ����������

--������� ����� 9
DECLARE @textparam nvarchar(50) = '��'
SELECT DISTINCT ���������� AS ����������
FROM �������
WHERE (����� = @textparam)

--������� ����� 10
SELECT top 1 with ties ���� AS ����
FROM �������
ORDER BY ����� * ���� desc

--������� ����� 11
SELECT ���� AS ����, SUM(����� * ����) AS �����
FROM �������
GROUP BY ����
