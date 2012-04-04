# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/dsdp/dsdp-5.8-r2.ebuild,v 1.1 2012/04/04 07:09:52 jlec Exp $

EAPI=4

inherit eutils toolchain-funcs versionator

MYP=DSDP${PV}

DESCRIPTION="Software for interior-point for semidefinite programming"
HOMEPAGE="http://www.mcs.anl.gov/hs/software/DSDP/"
SRC_URI="http://www.mcs.anl.gov/hs/software/DSDP//${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND="virtual/lapack"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${MYP}"

make_shared_lib() {
	local soname=$(basename "${1%.a}").so.$(get_major_version)
	einfo "Making ${soname}"
	${2:-$(tc-getCC)} ${LDFLAGS}  \
		-shared -Wl,-soname="${soname}" \
		-Wl,--whole-archive "${1}" -Wl,--no-whole-archive \
		-o $(dirname "${1}")/"${soname}" \
		-lm $(pkg-config --libs blas lapack) || return 1
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-readsdpa.patch \
		"${FILESDIR}"/${P}-gold.patch
	# to do proper parallel compilation
	find . -name Makefile -exec \
		sed -i -e 's:make :$(MAKE) :g' '{}' \;
	sed -i \
		-e "s|#\(DSDPROOT[[:space:]]*=\).*|\1${S}|" \
		-e "s|\(CC[[:space:]]*=\).*|\1$(tc-getCC)|" \
		-e "s|\(OPTFLAGS[[:space:]]*=\).*|\1${CFLAGS}|" \
		-e "s|\(CLINKER[[:space:]]*=\).*|\1 \${CC} ${LDFLAGS}|" \
		-e "s|\(LAPACKBLAS[[:space:]]*=\).*|\1 $(pkg-config --libs blas lapack)|" \
		-e "s|\(^ARCH[[:space:]]*=\).*|\1$(tc-getAR) cr|" \
		-e "s|\(^RANLIB[[:space:]]*=\).*|\1$(tc-getRANLIB)|" \
		make.include || die
}

src_compile() {
	emake OPTFLAGS="${CFLAGS} -fPIC" dsdplibrary
	make_shared_lib lib/lib${PN}.a || die "doing shared lib failed"
}

src_test() {
	emake -j1 example test
}

src_install() {
	dolib.so lib/lib${PN}.so.$(get_major_version)
	dosym lib${PN}.so.$(get_major_version) /usr/$(get_libdir)/lib${PN}.so

	insinto /usr/include
	doins include/*.h src/sdp/*.h

	use doc && dodoc docs/*.pdf

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
