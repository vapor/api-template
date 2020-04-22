# ================================
# Build image
# ================================
FROM vapor/swift:5.2 as build
WORKDIR /build

# Copy entire repo into container
COPY . .

# Install sqlite3
RUN apt-get update -y \
	&& apt-get install -y libsqlite3-dev

# Compile with optimizations
RUN swift build \
	--enable-test-discovery \
	-c release \
	-Xswiftc -g

# ================================
# Run image
# ================================
FROM vapor/ubuntu:18.04
WORKDIR /app

ENV PORT 80

# Copy build artifacts
COPY --from=build /build/.build/release /app
# Copy Swift runtime libraries
COPY --from=build /usr/lib/swift/ /usr/lib/swift/

CMD ./Run serve --env production --hostname 0.0.0.0 --port $PORT
