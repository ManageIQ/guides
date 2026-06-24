## Service UI Development

The ManageIQ Service UI is a separate Angular-based application that provides a self-service portal interface for ManageIQ. This guide covers setting up the Service UI for local development.

### Prerequisites

Before setting up the Service UI, ensure you have:

- ManageIQ API running locally (typically on `http://localhost:3000`)
- NodeJS and yarn installed (see [Requirements Summary](../developer_setup.md#requirements-summary))
- The ManageIQ repository cloned and configured

### Clone the Service UI Repository

Clone the Service UI repository into a sibling directory to your ManageIQ installation:

```bash
cd ..  # Navigate to the parent directory of manageiq
git clone https://github.com/ManageIQ/manageiq-ui-service.git
cd manageiq-ui-service
```

Your directory structure should look like:

```
parent-directory/
├── manageiq/
└── manageiq-ui-service/
```

### Install Dependencies

Install the required Node packages using yarn:

```bash
yarn install
```

### Start the Development Server

Start the Service UI development server:

```bash
npm run start
```

The Service UI will be available at `http://localhost:3001`.

### Verify the Setup

1. Ensure the ManageIQ API is running on `http://localhost:3000`
2. Open your browser to `http://localhost:3001`
3. Log in using the default credentials:
   - Username: `admin`
   - Password: `smartvm`

If you can successfully log in and see the Service UI interface, your setup is complete!

### Development Workflow

- The Service UI development server supports hot reloading, so changes to the code will automatically refresh in the browser
- The Service UI communicates with the ManageIQ API running on port 3000
- Both the ManageIQ API server and the Service UI development server need to be running simultaneously for development

### Further Reading

- [Service UI Skinning Guide](../service_ui/skinning.md)
- [ManageIQ Service UI Repository](https://github.com/ManageIQ/manageiq-ui-service)
