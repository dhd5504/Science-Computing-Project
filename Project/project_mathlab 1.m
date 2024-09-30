a= 110 %Độ khuếch tán của pt nhiệt
length = 50 % Kích thước tấm lưới
time = 1 %hiết lập thời gian
nodes = 40 %Thiết lập số điểm ảnh

dx = length / nodes; % dx=0.8
dy = length / nodes; % dy=0.8
dt = min(dx^2 / (4 * a), dy^2 / (4 * a)); % dt = 3.2*10^-3
t_nodes = floor(time/dt); %Xác định số lần lặp và kết quả là một số  và t_nodes=312 do floor là hàm lấy phần nguyên
u = zeros(nodes, nodes) + 20; % Khởi tạo nhiệt độ ban đầu của cả tấm là 20 và được lưu ở không gian 2 chiều có kích thước là node x node

% Do là mô tả nhiệt là từ trung tâm phân tán nhiệt ra các hướng xung quanh nên cần thiết lặp lại nhiệt độ ban đầu cảu tấm ở giữa
center = floor(nodes/2) + 1; % Tìm vị trí trung tâm của tấm vật liệu
size = 12; % Khởi tạo nhiệt độ cho vùng bị đốt nóng bởi nhiệt là 1 vùng hình vuông có kích thước 12 x 12
half = floor(size/2); %Tính điểm giữa của vùng bị đốt nhiệt
% Sau khi xác định được các vị trí cần nhiết của vùng được đót bởi nhiệt thì ta tiến hành khởi tạo giá trị nhiệt = 100 tại vùng đó hay nói cách khác thì đây là vùng nóng nhất của tấm vật liệu
for i = center-half : center + half
    for j = center-half : center + half
        u(i, j) = 100;
    end
end

%Sau khi chuẩn bị xong thì đến với phần hiển thị mô phỏng bài toán
figure();

subplot(1, 2, 1); % Chia màn hình hiển thị làm 2 phần bên trái và bên phải mục đích để hiển thị 2 biểu đồ nhiệt theo 2 chiều
h = pcolor(u);  % Hiển thị màu ra đồ thị
set(h, 'EdgeColor', 'none'); % Xóa các đường kẻ trên đồ thị
colormap(jet); % Lựa chọn bảng màu phù hợp
colorbar; % Tạo thanh màu
caxis([0 100]); % Tạo giới hạn sau khi thêm câu lệnh này thì màu của đồ thị hiển thị tấm kim loại sẽ được lấy theo giá trị màu ở thanh màu

%Sau khi tạo hình cũng như tạo màu xong ta sẽ đến công đoạn tạo sự truyền nhiệt theo công thức đã được chứng minh
counter = 0; %Thiết lặp thời gian ban đầu
index = 1;   %Thiết lặp chỉ số lần lặp

while counter < time  % cho vòng lặp chạy đến khi đạt tới giới hạn đã được định
    w = u;
    %Tính giá trị nhiệt tại thời điểm
    for i = 2:nodes-1
        for j = 2:nodes-1
            dd_ux = (w(i-1, j) - 2*w(i, j) + w(i+1, j)) / dx^2;
            dd_uy = (w(i, j-1) - 2*w(i, j) + w(i, j+1)) / dy^2;
            u(i, j) = dt * a * (dd_ux + dd_uy) + w(i, j);
        end
    end
    counter = counter + dt;

    % Update pcolor plot
    subplot(1, 2, 1);
    h = pcolor(u);
    set(h, 'EdgeColor', 'none');
    colormap(jet);
    colorbar;
    caxis([0 100]);

    % Update surf plot
    subplot(1, 2, 2);
    w0 = w;
    for i = 2:nodes-1
        for j = 2:nodes-1
            w(i,j) = w0(i,j) + u(i,j);
        end
    end
    X = 2:nodes-1;
    Y = 2:nodes-1;
    Z = w(X,Y);
    surf(X, Y, Z);
    zlim([40, 200]);
    %h_2=pcolor(u)
    % Updating the plot
    set(h, 'CData', u);
    colormap(jet);
    colorbar;
    caxis([0 100]);

    title(sprintf("Distribution at t: %.3f [s].", counter));
    pause(0.01);
    %Lưu nhiệt độ tại điểm trung tâm
    center_temperatures(index) = u(center, center);
    time_temperatures(index) = counter;
    %Lưu nhiệt độ trung bình của cả tấm đồng
    avg_temperatures(index) = mean(u, 'all');
    %pause(0.01);
    index = index + 1;
end

% Show final plot
title(sprintf("Final temperature distribution at t: %.3f [s].", counter));

% Vẽ đồ thị
figure();
plot(time_temperatures,center_temperatures, 'b');
legend('Nhiệt độ trung tâm');
xlabel('Thời gian');
ylabel('Nhiệt độ (°C)');
title('Biểu đồ nhiệt độ');

% Show final plot
title('Final temperature distribution');

% Vẽ đồ thị
figure();
x_values = 0 : 1000;
plot(time_temperatures,avg_temperatures, 'b');
legend('Nhiệt độ trung bình');
xlabel('Thời gian');
ylabel('Nhiệt độ (°C)');
title('Biểu đồ nhiệt độ');
