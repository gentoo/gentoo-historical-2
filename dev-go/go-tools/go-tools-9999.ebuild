# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/go-tools/go-tools-9999.ebuild,v 1.8 2015/06/26 14:30:05 williamh Exp $

EAPI=5
inherit golang-build golang-vcs
EGO_PN=golang.org/x/tools/...
EGO_SRC=golang.org/x/tools
ICON_URI="http://golang.org/favicon.ico -> go-favicon.ico"

DESCRIPTION="Go Tools"
HOMEPAGE="https://godoc.org/x/tools"
SRC_URI="${ICON_URI}"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND="dev-go/go-net"
RDEPEND=""

src_prepare() {
	# disable broken tests
	sed -e 's:TestWeb(:_\0:' \
		-i src/${EGO_SRC}/cmd/godoc/godoc_test.go || die
	sed -e 's:TestVet(:_\0:' \
		-i src/${EGO_SRC}/cmd/vet/vet_test.go || die
	sed -e 's:TestImport(:_\0:' \
		-i src/${EGO_SRC}/go/gcimporter/gcimporter_test.go || die
	sed -e 's:TestImportStdLib(:_\0:' \
		-i src/${EGO_SRC}/go/importer/import_test.go || die
	sed -e 's:TestStdlib(:_\0:' \
		-i src/${EGO_SRC}/go/loader/stdlib_test.go || die
	sed -e 's:TestStdlib(:_\0:' \
		-i src/${EGO_SRC}/go/ssa/stdlib_test.go || die
	sed -e 's:TestGorootTest(:_\0:' \
		-e 's:TestFoo(:_\0:' \
		-e 's:TestTestmainPackage(:_\0:' \
		-i src/${EGO_SRC}/go/ssa/interp/interp_test.go || die
	sed -e 's:TestBar(:_\0:' \
		-e 's:TestFoo(:_\0:' \
		-i src/${EGO_SRC}/go/ssa/interp/testdata/a_test.go || die
	sed -e 's:TestCheck(:_\0:' \
		-i src/${EGO_SRC}/go/types/check_test.go || die
	sed -e 's:TestStdlib(:_\0:' \
		-e 's:TestStdFixed(:_\0:' \
		-e 's:TestStdKen(:_\0:' \
		-i src/${EGO_SRC}/go/types/stdlib_test.go || die
	sed -e 's:TestRepoRootForImportPath(:_\0:' \
		-i src/${EGO_SRC}/go/vcs/vcs_test.go || die
	sed -e 's:TestStdlib(:_\0:' \
	-i src/${EGO_SRC}/refactor/lexical/lexical_test.go || die

	# Add favicon to the godoc web interface (bug 551030)
	cp "${DISTDIR}"/go-favicon.ico "src/${EGO_SRC}/godoc/static/favicon.ico" ||
		die
	sed -e 's:"example.html",:\0\n\t"favicon.ico",:' \
		-i src/${EGO_SRC}/godoc/static/makestatic.go || die
	sed -e 's:<link type="text/css":<link rel="icon" type="image/png" href="/lib/godoc/favicon.ico">\n\0:' \
		-i src/${EGO_SRC}/godoc/static/godoc.html || die
}

src_compile() {
	# Generate static.go with favicon included
	pushd src/golang.org/x/tools/godoc/static >/dev/null || die
	go run makestatic.go || die
	popd >/dev/null

	golang-build_src_compile
}

src_install() {
	# Create a writable GOROOT in order to avoid sandbox violations.
	cp -sR "$(go env GOROOT)" "${T}/goroot" || die

	GOROOT="${T}/goroot" golang-build_src_install
	dobin bin/* "${T}/goroot/bin/godoc"

	exeinto "$(go env GOTOOLDIR)"
	exeopts -m0755 -p # preserve timestamps for bug 551486
	doexe "${T}/goroot/pkg/tool/$(go env GOOS)_$(go env GOARCH)/cover"
	doexe "${T}/goroot/pkg/tool/$(go env GOOS)_$(go env GOARCH)/vet"
}
