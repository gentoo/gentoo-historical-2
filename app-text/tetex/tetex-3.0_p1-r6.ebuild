# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/tetex/tetex-3.0_p1-r6.ebuild,v 1.1 2007/11/15 18:02:20 aballier Exp $

inherit tetex-3 flag-o-matic versionator virtualx autotools

SMALL_PV=$(get_version_component_range 1-2 ${PV})
TETEX_TEXMF_PV=${SMALL_PV}
S="${WORKDIR}/tetex-src-${SMALL_PV}"

TETEX_SRC="tetex-src-${PV}.tar.gz"
TETEX_TEXMF="tetex-texmf-${TETEX_TEXMF_PV:-${TETEX_PV}}.tar.gz"
#TETEX_TEXMF_SRC="tetex-texmfsrc-${TETEX_TEXMF_PV:-${TETEX_PV}}.tar.gz"
TETEX_TEXMF_SRC=""

DESCRIPTION="a complete TeX distribution"
HOMEPAGE="http://tug.org/teTeX/"

SRC_PATH_TETEX=ftp://cam.ctan.org/tex-archive/systems/unix/teTeX/current/distrib
SRC_URI="mirror://gentoo/${TETEX_SRC}
	${SRC_PATH_TETEX}/${TETEX_TEXMF}
	mirror://gentoo/${P}-gentoo.tar.gz
	mirror://gentoo/${P}-dviljk-security-fixes.patch.bz2"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"

# these are defined in tetex.eclass and tetex-3.eclass
IUSE=""
DEPEND="${DEPEND} media-libs/gd"
RDEPEND="${RDEPEND} media-libs/gd"

src_unpack() {
	tetex-3_src_unpack
	cd "${WORKDIR}"
	unpack ${P}-dviljk-security-fixes.patch.bz2
	cd "${S}"
	epatch "${FILESDIR}/${PN}-${SMALL_PV}-kpathsea-pic.patch"

	# bug 85404
	epatch "${FILESDIR}/${PN}-${SMALL_PV}-epstopdf-wrong-rotation.patch"

	epatch "${FILESDIR}/${P}-amd64-xdvik-wp.patch"
	epatch "${FILESDIR}/${P}-mptest.patch"

	#bug 98029
	epatch "${FILESDIR}/${P}-fmtutil-etex.patch"

	#bug 115775
	epatch "${FILESDIR}/${P}-xpdf-vulnerabilities.patch"

	# bug 94860
	epatch "${FILESDIR}/${P}-pdftosrc-install.patch"

	# bug 126918
	epatch "${FILESDIR}/${P}-create-empty-files.patch"

	# bug 94901
	epatch "${FILESDIR}/${P}-dvipdfm-timezone.patch"

	# security bug #170861
	epatch "${FILESDIR}/${P}-CVE-2007-0650.patch"

	# security bug #188172
	epatch "${FILESDIR}/${P}-xpdf-CVE-2007-3387.patch"

	# security bug #198238
	epatch "${FILESDIR}/${P}-dvips_bufferoverflow.patch"

	# securty bug #196735
	epatch "${FILESDIR}/xpdf-3.02pl2.patch"

	# Construct a Gentoo site texmf directory
	# that overlays the upstream supplied
	epatch "${FILESDIR}/${P}-texmf-site.patch"

	# security bug #198238
	epatch "${WORKDIR}/${P}-dviljk-security-fixes.patch"

	# security bug #198238 and bug #193437
	epatch "${FILESDIR}/${P}-t1lib-SA26241_buffer_overflow.patch"

	cd "${S}/texk/dviljk"
	AT_M4DIR="${S}/texk/m4" eautoreconf
}

src_compile() {
	#bug 119856
	export LC_ALL=C

	# dvipng has its own ebuild (fix for bug #129044).
	# also, do not build against own lib gd (security #182055)
	TETEX_ECONF="${TETEX_ECONF} --without-dvipng --with-system-gd"

	tetex-3_src_compile
}

src_test() {
	fmtutil --fmtdir "${S}/texk/web2c" --all
	# The check target tries to access X display, bug #69439.
	Xmake check || die "Xmake check failed."
}

src_install() {
	insinto /usr/share/texmf/dvips/pstricks
	doins "${FILESDIR}/pst-circ.pro"

	# install pdftosrc man page, bug 94860
	doman "${S}/texk/web2c/pdftexdir/pdftosrc.1"

	tetex-3_src_install

	# Create Gentoo site texmf directory
	keepdir /usr/share/texmf-site
}

pkg_postinst() {
	tetex-3_pkg_postinst

	elog
	elog "This release removes dvipng since it is provided in app-text/dvipng"
	elog
}
