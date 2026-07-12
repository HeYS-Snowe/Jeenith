# 技术选型报告 Technology Selection Report

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 文档版本 Document Version | v0.1.0（初期草稿） |
| 创建日期 Created Date | 2026-07-05 |
| 最后修改 Last Modified | 2026-07-05 |
| 技术负责人 Tech Lead | 待定 |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 审核人 Reviewer | 修改内容 Description |
|-------------|---------|---------------|---------------|-------------------|
| v0.1.0 | 2026-07-05 | 待定 | | 初始版本，移动端确认 Flutter，其余待定 Initial info filled |

---

## 目录 Table of Contents

1. [选型概述 Selection Overview](#1-选型概述-selection-overview)
2. [选型原则 Selection Principles](#2-选型原则-selection-principles)
3. [前端技术选型 Frontend Selection](#3-前端技术选型-frontend-selection)
4. [后端技术选型 Backend Selection](#4-后端技术选型-backend-selection)
5. [数据存储选型 Data Storage Selection](#5-数据存储选型-data-storage-selection)
6. [基础设施选型 Infrastructure Selection](#6-基础设施选型-infrastructure-selection)
7. [选型汇总 Selection Summary](#7-选型汇总-selection-summary)

---

## ⚠️ 项目实际决策 Project Actual Decisions（v0.2.0 / 2026-07-05 更新）

> 以下为项目正式启动后的实际技术决策，**覆盖下方所有模板默认值**。下方模板内容（Java/Spring Boot、Vue/Web/Electron/小程序多端、桌面端、服务端集中推理）仅作参考，**不再代表本项目选型**。

| 层级 Layer | 实际选型 Actual Choice | 说明 Notes |
|---|---|---|
| 移动端 Mobile | **Flutter**（状态管理 Riverpod，路由 go_router） | iOS/Android 双端，**唯一客户端** |
| 后端 Backend | **Python 3.11 + FastAPI** | 替代模板 Java/Spring Boot。理由：AI/CV 推理生态（PyTorch/YOLO/OpenCV）在 Python，FastAPI 异步契合实时预警推送 |
| AI 识别 AI Inference | **边缘侧**（摄像头/边缘盒子本地推理） | 服务端只接收结构化识别结果，不做集中视频推理。带宽低、延迟低、隐私好 |
| Web 管理后台 Web Admin | **MVP 不做**，仅 Flutter App | 管理者也用 App，后续视需要再评估 |
| 数据库 Database | 候选 PostgreSQL / MySQL（待 Claude 最终确认） | 倾向 PostgreSQL |
| 实时通道 Realtime | WebSocket / MQTT（待定） | 预警秒级推送 |
| 消息队列 MQ | 待定 | 边缘 → 服务端识别结果接入与异步处理 |

**已废弃模板默认值**：Java/Spring Boot、Vue/Web/Electron/小程序多端、桌面端、服务端集中推理——均不适用本项目。

---

## 1. 选型概述 Selection Overview

### 1.1 选型目标 Selection Goals

| 目标维度 Goal Dimension | 说明 Description |
|---------------------|---------------|
| 业务匹配 Business Fit | 满足当前业务需求，支持未来扩展 |
| 团队能力 Team Capability | 团队具备相应技术能力或学习成本可控 |
| 成本控制 Cost | 综合考虑开发、运维、人力成本 |
| 生态支持 Ecosystem | 社区活跃，文档完善，第三方库丰富 |
| 稳定性 Stability | 技术成熟，有大规模应用案例 |

### 1.2 选型流程 Selection Process

```
需求分析 → 方案调研 → 对比评估 → PoC验证 → 决策落地
   │          │          │         │         │
需求文档   调研报告   评分矩阵   验证报告   决策文档
```

---

## 2. 选型原则 Selection Principles

### 2.1 评估维度 Evaluation Dimensions

| 维度 Dimension | 权重 Weight | 说明 Description |
|--------------|-----------|---------------|
| 功能性 Functionality | 25% | 是否满足功能需求 |
| 性能 Performance | 20% | 性能表现如何 |
| 可维护性 Maintainability | 15% | 代码可读性、调试便利性 |
| 学习成本 Learning Curve | 15% | 团队上手难度 |
| 生态社区 Ecosystem | 15% | 社区活跃度、文档质量 |
| 成本 Cost | 10% | 开发和运维成本 |

### 2.2 评分标准 Scoring Criteria

| 分数 Score | 评价 Evaluation |
|----------|--------------|
| 5分 Excellent | 完全满足，表现优异 |
| 4分 Good | 满足需求，表现良好 |
| 3分 Average | 基本满足，表现一般 |
| 2分 Fair | 部分满足，存在不足 |
| 1分 Poor | 不满足需求 |

---

## 3. 前端技术选型 Frontend Selection

### 3.1 Web前端框架选择 Web Framework Selection

| 对比项 Comparison | Vue.js | React | Angular |
|-----------------|--------|-------|---------|
| **功能性 Functionality (25%)** | | | |
| 组件化 Component | 5 | 5 | 5 |
| 状态管理 State Management | 4 | 5 | 5 |
| 路由 Routing | 5 | 4 | 5 |
| **性能 Performance (20%)** | | | |
| 运行时性能 Runtime | 4 | 5 | 3 |
| 包体积 Bundle Size | 5 | 4 | 2 |
| **可维护性 Maintainability (15%)** | | | |
| 代码规范 Code Style | 4 | 4 | 5 |
| TypeScript支持 TS Support | 5 | 5 | 5 |
| 调试工具 Debugging | 4 | 5 | 4 |
| **学习成本 Learning Curve (15%)** | | | |
| 入门难度 Getting Started | 5 | 3 | 2 |
| 概念复杂度 Concept Complexity | 4 | 3 | 2 |
| **生态社区 Ecosystem (15%)** | | | |
| 社区活跃度 Activity | 5 | 5 | 4 |
| 第三方库 3rd Party Libraries | 4 | 5 | 4 |
| 文档质量 Documentation | 5 | 4 | 4 |
| **成本 Cost (10%)** | | | |
| 开发效率 Development Speed | 5 | 4 | 3 |
| **总分 Total Score** | **59** | **56** | **53** |

**选择结果 Decision:** **Vue.js 3**

| 理由 Rationale |
|--------------|
| 上手快，团队熟悉度高 |
| 性能优异，包体积小 |
| 中文文档完善 |
| 生态丰富，组件库齐全 |

### 3.2 前端技术栈 Frontend Tech Stack

| 技术 Technology | 选型 Choice | 版本 Version | 说明 Notes |
|--------------|-----------|------------|----------|
| 框架 Framework | Vue.js | 3.x | 渐进式框架 |
| 状态管理 State | Pinia | 2.x | 官方推荐状态管理 |
| UI组件库 UI Library | Element Plus / Ant Design Vue | latest | 企业级UI组件 |
| 构建工具 Build Tool | Vite | 5.x | 新一代前端构建工具 |
| CSS方案 CSS | Tailwind CSS / UnoCSS | latest | 原子化CSS |
| HTTP客户端 HTTP | Axios | 1.x | HTTP请求库 |
| TypeScript | TypeScript | 5.x | 类型安全 |

### 3.3 移动端技术选型 Mobile Selection

| 对比项 Comparison | React Native | Flutter | 原生开发 |
|-----------------|-------------|---------|---------|
| 开发效率 Development Efficiency | 4 | 5 | 3 |
| 性能表现 Performance | 4 | 5 | 5 |
| 热更新 Hot Update | 支持 | 支持 | 不支持 |
| 学习成本 Learning Cost | 3(需React) | 3 | 5 |
| 生态社区 Ecosystem | 5 | 4 | 5 |
| **总分 Total** | **20** | **21** | **23** |

**选择结果 Decision:** **Flutter**

| 理由 Rationale |
|--------------|
| 高性能，接近原生体验 |
| 热重载，开发效率高 |
| 统一代码库，iOS/Android一套代码 |
| UI渲染能力强 |

### 3.4 桌面端技术选型 Desktop Selection

| 对比项 Comparison | Electron | Tauri | 原生开发 |
|-----------------|---------|-------|---------|
| 跨平台 Cross-Platform | 5 | 5 | 2 |
| 包体积 Bundle Size | 2 | 5 | 5 |
| 性能 Performance | 3 | 5 | 5 |
| 开发效率 Development | 5 | 4 | 2 |
| 生态社区 Ecosystem | 5 | 3 | 5 |
| **总分 Total** | **20** | **22** | **19** |

**选择结果 Decision:** **Electron** (当前稳定) / **Tauri** (未来考虑)

---

## 4. 后端技术选型 Backend Selection

### 4.1 后端语言和框架选择 Backend Language & Framework

| 对比项 Comparison | Java + Spring Boot | Node.js + NestJS | Go + Gin |
|-----------------|-------------------|------------------|---------|
| **功能性 Functionality (25%)** | | | |
| 生态完善度 Ecosystem | 5 | 4 | 3 |
| 并发处理 Concurrency | 4 | 4 | 5 |
| 企业级支持 Enterprise Support | 5 | 3 | 3 |
| **性能 Performance (20%)** | | | |
| 吞吐量 Throughput | 4 | 4 | 5 |
| 响应时间 Latency | 4 | 4 | 5 |
| 资源占用 Resource Usage | 3 | 4 | 5 |
| **可维护性 Maintainability (15%)** | | | |
| 代码规范 Code Style | 5 | 4 | 4 |
| 类型安全 Type Safety | 5 | 3(TS) | 4 |
| 调试工具 Debugging | 5 | 4 | 4 |
| **学习成本 Learning Curve (15%)** | | | |
| 入门难度 Getting Started | 3 | 4 | 3 |
| 团队熟悉度 Team Familiarity | 5 | 3 | 2 |
| **生态社区 Ecosystem (15%)** | | | |
| 社区活跃度 Activity | 5 | 5 | 5 |
| 第三方库 Libraries | 5 | 5 | 4 |
| 文档质量 Documentation | 5 | 4 | 4 |
| **成本 Cost (10%)** | | | |
| 开发效率 Development | 4 | 4 | 4 |
| **总分 Total Score** | **56** | **51** | **54** |

**选择结果 Decision:** **Java + Spring Boot**

| 理由 Rationale |
|--------------|
| 团队熟悉，学习成本低 |
| 生态完善，企业级支持好 |
| 类型安全，可维护性高 |
| 有丰富的微服务支持 |

### 4.2 后端技术栈 Backend Tech Stack

| 技术 Technology | 选型 Choice | 版本 Version | 说明 Notes |
|--------------|-----------|------------|----------|
| 开发语言 Language | Java | 17 LTS | LTS长期支持版本 |
| 框架 Framework | Spring Boot | 3.x | 企业级框架 |
| 安全框架 Security | Spring Security + JWT | 6.x | 认证授权 |
| ORM框架 ORM | MyBatis-Plus | 3.x | 持久层框架 |
| 数据库验证 Validation | Hibernate Validator | 8.x | Bean验证 |
| 文档文档 API Doc | SpringDoc/OpenAPI | 2.x | API文档 |
| 日志框架 Logging | SLF4J + Logback | 2.x | 日志记录 |
| 缓存抽象 Caching | Spring Cache | 3.x | 缓存抽象 |
| 测试框架 Testing | JUnit 5 + Mockito | 5.x | 单元测试 |

### 4.3 API设计风格 API Design Style

| 风格 Style | 优点 Pros | 缺点 Cons | 选择 Selection |
|----------|---------|---------|--------------|
| RESTful | 简单、通用、缓存友好 | 过度/不足获取、多次请求 | ✅ 选择 |
| GraphQL | 按需获取、单次请求 | 学习成本高、缓存复杂 | |
| gRPC | 高性能、类型安全 | 不适合浏览器 | |

**选择结果:** RESTful + OpenAPI 3.0

---

## 5. 数据存储选型 Data Storage Selection

### 5.1 关系型数据库选择 Relational Database

| 对比项 Comparison | MySQL | PostgreSQL | Oracle |
|-----------------|--------|-----------|--------|
| 开源免费 Open Source | ✅ 是 | ✅ 是 | ❌ 否 |
| 性能 Performance | 4 | 5 | 5 |
| 可扩展性 Scalability | 4 | 5 | 5 |
| 社区活跃度 Community | 5 | 5 | 4 |
| 运维复杂度 Operations | 3 | 4 | 2 |
| 团队熟悉度 Team Familiarity | 5 | 3 | 2 |
| 云服务支持 Cloud Support | 5 | 5 | 5 |
| **总分 Total** | **30** | **32** | **28** |

**选择结果 Decision:** **MySQL 8.0+**

| 理由 Rationale |
|--------------|
| 开源免费，成本低 |
| 社区活跃，文档丰富 |
| 团队熟悉度高 |
| 云服务支持完善 |

### 5.2 缓存数据库选择 Cache Database

| 对比项 Comparison | Redis | Memcached |
|-----------------|-------|-----------|
| 数据结构 Data Structures | 丰富 5 | 简单 2 |
| 持久化 Persistence | 支持 5 | 不支持 1 |
| 集群模式 Cluster | 成熟 5 | 有限 2 |
| 性能 Performance | 高 5 | 高 5 |
| 社区活跃度 Community | 5 | 3 |
| **总分 Total** | **25** | **13** |

**选择结果 Decision:** **Redis 7.x**

### 5.3 消息队列选择 Message Queue

| 对比项 Comparison | RabbitMQ | Apache Kafka | RocketMQ |
|-----------------|----------|-------------|----------|
| 吞吐量 Throughput | 万级 | 十万级 | 十万级 |
| 延迟 Latency | 微秒级 | 毫秒级 | 毫秒级 |
| 可靠性 Reliability | 高 | 高 | 高 |
| 社区活跃度 Community | 5 | 5 | 3 |
| 运维复杂度 Operations | 3 | 3 | 2 |
| **总分 Total** | **16** | **18** | **14** |

**选择结果 Decision:** **RabbitMQ** (中小规模) / **Kafka** (大规模)

### 5.4 搜索引擎选择 Search Engine

| 对比项 Comparison | Elasticsearch | Solr | MySQL Fulltext |
|-----------------|---------------|------|----------------|
| 搜索功能 Search | 5 | 5 | 2 |
| 分布式 Distributed | 5 | 4 | 1 |
| 实时性 Real-time | 4 | 3 | 5 |
| 运维复杂度 Operations | 3 | 3 | 5 |
| **总分 Total** | **20** | **17** | **15** |

**选择结果 Decision:** **Elasticsearch 8.x**

### 5.5 文件存储选择 File Storage

| 对比项 Comparison | 对象存储OSS | 自建NAS | 本地存储 |
|-----------------|-----------|---------|---------|
| 成本 Cost | 中 | 高 | 低 |
| 可靠性 Reliability | 高 | 中 | 低 |
| 扩展性 Scalability | 高 | 中 | 低 |
| 运维复杂度 Operations | 低 | 高 | 中 |
| CDN集成 CDN Integration | 支持 | 不支持 | 不支持 |
| **总分 Total** | **选择** | | |

**选择结果 Decision:** **阿里云OSS / 腾讯云COS**

---

## 6. 基础设施选型 Infrastructure Selection

### 6.1 容器化选择 Containerization

| 对比项 Comparison | Docker | Podman |
|-----------------|--------|--------|
| 生态支持 Ecosystem | 5 | 3 |
| 安全性 Security | 3 | 5 |
| 兼容性 Compatibility | 5 | 4 |
| **总分 Total** | **13** | **12** |

**选择结果 Decision:** **Docker**

### 6.2 容器编排选择 Container Orchestration

| 对比项 Comparison | Kubernetes | Docker Swarm |
|-----------------|-----------|-------------|
| 功能丰富度 Features | 5 | 3 |
| 社区支持 Community | 5 | 2 |
| 学习曲线 Learning Curve | 2 | 4 |
| 扩展性 Scalability | 5 | 3 |
| **总分 Total** | **22** | **15** |

**选择结果 Decision:** **Kubernetes (K8s)**

### 6.3 CI/CD选择

| 对比项 Comparison | Jenkins | GitLab CI | GitHub Actions |
|-----------------|---------|-----------|---------------|
| 功能性 Functionality | 5 | 4 | 4 |
| 易用性 Ease of Use | 3 | 5 | 5 |
| 集成能力 Integration | 5 | 4 | 5 |
| 成本 Cost | 4(自建) | 4 | 5(免费额度) |
| **总分 Total** | **21** | **21** | **23** |

**选择结果 Decision:** **GitLab CI** (代码托管) / **GitHub Actions** (开源项目)

### 6.4 监控方案选择 Monitoring

| 对比项 Comparison | Prometheus + Grafana | Zabbix | ELK Stack |
|-----------------|---------------------|--------|-----------|
| 指标收集 Metrics | 5 | 5 | 3 |
| 可视化 Visualization | 5 | 3 | 3 |
| 告警 Alerting | 5 | 5 | 3 |
| 日志分析 Log Analysis | 2 | 3 | 5 |
| **总分 Total** | **22** | **21** | **19** |

**选择结果 Decision:** **Prometheus + Grafana + ELK**

---

## 7. 选型汇总 Selection Summary

### 7.1 技术栈全景图 Tech Stack Overview

```
┌────────────────────────────────────────────────────────────────┐
│                         前端层 Frontend                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │   Web    │  │  Mobile  │  │ Desktop  │  │   小程序   │      │
│  │  Vue3    │  │ Flutter  │  │ Electron │  │  原生/Uni │      │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘      │
└────────────────────────────────────────────────────────────────┘
                              │ HTTPS/HTTP
                              ▼
┌────────────────────────────────────────────────────────────────┐
│                         网关层 Gateway                        │
│                   Nginx / API Gateway / K8s Ingress          │
└────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────────┐
│                       应用层 Application                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ Java     │  │ Node.js  │  │ Python   │  │  Go      │      │
│  │SpringBoot│  │  (可选)  │  │ (脚本)   │  │ (可选)   │      │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘      │
└────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────────┐
│                       数据层 Data Layer                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │  MySQL   │  │  Redis   │  │ RabbitMQ │  │    ES    │      │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘      │
│  ┌──────────┐  ┌──────────┐                                  │
│  │   OSS    │  │ MongoDB  │                                  │
│  └──────────┘  └──────────┘                                  │
└────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────────┐
│                       基础设施 Infrastructure                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │   K8s    │  │  Docker  │  │ GitLab CI│  │Prometheus│      │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘      │
└────────────────────────────────────────────────────────────────┘
```

### 7.2 最终技术选型 Final Technology Stack

> 项目确认：**移动端 = Flutter（已定）**。其余层级（后端、数据存储、基础设施、是否有 Web 管理后台、AI 识别部署位置）待系统架构设计阶段确认后最终落地。下表为模板默认值，非最终结论。

| 层级 Layer | 技术选型 Technology | 版本 Version |
|----------|-------------------|------------|
| **前端框架 Frontend** | | |
| Web框架 | Vue.js | 3.x |
| UI组件 | Element Plus | latest |
| 构建工具 | Vite | 5.x |
| 状态管理 | Pinia | 2.x |
| 移动端 | Flutter | 3.x |
| 桌面端 | Electron | latest |
| **后端框架 Backend** | | |
| 语言 | Java | 17 LTS |
| 框架 | Spring Boot | 3.x |
| 安全 | Spring Security + JWT | 6.x |
| ORM | MyBatis-Plus | 3.x |
| **数据存储 Data** | | |
| 关系数据库 | MySQL | 8.0+ |
| 缓存 | Redis | 7.x |
| 消息队列 | RabbitMQ | 3.x |
| 搜索引擎 | Elasticsearch | 8.x |
| 文件存储 | 阿里云OSS | - |
| **基础设施 Infrastructure** | | |
| 容器 | Docker | 24.x |
| 编排 | Kubernetes | 1.28+ |
| CI/CD | GitLab CI | - |
| 监控 | Prometheus + Grafana | - |
| 日志 | ELK Stack | 8.x |

### 7.3 技术风险与应对 Tech Risks & Mitigation

| 风险 Risk | 影响 Impact | 应对措施 Mitigation |
|----------|-----------|------------------|
| 新技术学习成本高 | 开发效率下降 | 提前培训，技术分享 |
| 开源项目维护中断 | 长期维护风险 | 选择成熟稳定项目 |
| 第三方服务依赖 | 服务可用性风险 | 准备备用方案 |
| 性能瓶颈 | 用户体验下降 | 压测验证，优化预案 |

---

## 附录 Appendix

### 附录A：参考文档 References

| 文档 Document | 链接 Link |
|-------------|---------|
| Vue.js官方文档 | https://vuejs.org |
| Spring Boot官方文档 | https://spring.io/projects/spring-boot |
| MySQL官方文档 | https://dev.mysql.com/doc |

### 附录B：技术调研报告 Research Reports

| 技术点 Technology | 调研报告 Research Report | 链接 Link |
|----------------|----------------------|---------|
| | | |

---

## 审批与签署 Approvals

| 角色 Role | 姓名 Name | 签名 Signature | 日期 Date |
|----------|---------|--------------|---------|
| 技术负责人 Tech Lead | | | |
| 架构师 Architect | | | |
| CTO | | | |

---

**文档结束 End of Document**
