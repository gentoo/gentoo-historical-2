# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/unison/unison-2.27.57-r1.ebuild,v 1.9 2008/06/26 00:05:41 gentoofan23 Exp $

EAPI=1

inherit eutils versionator

IUSE="gtk doc static debug threads +ocamlopt"

DESCRIPTION="Two-way cross-platform file synchronizer"
HOMEPAGE="http://www.cis.upenn.edu/~bcpierce/unison/"
LICENSE="GPL-2"
SLOT="$(get_version_component_range 1-2 ${PV})"
KEYWORDS="amd64 ppc ~sparc x86"

DEPEND=">=dev-lang/ocaml-3.04
	gtk? ( >=dev-ml/lablgtk-2.2 )"

RDEPEND="gtk? ( >=dev-ml/lablgtk-2.2
|| ( net-misc/x11-ssh-askpass net-misc/gtk2-ssh-askpass ) )
	!net-misc/unison:0
	app-admin/eselect-unison"

PDEPEND="gtk? ( media-fonts/font-schumacher-misc )"

SRC_URI="http://www.cis.upenn.edu/~bcpierce/unison/download/releases/${P}/${P}.tar.gz
doc? ( http://www.cis.upenn.edu/~bcpierce/unison/download/releases/${P}/${P}-manual.pdf
	http://www.cis.upenn.edu/~bcpierce/unison/download/releases/${P}/${P}-manual.html )"

pkg_setup() {
	if use ocamlopt && ! built_with_use --missing true dev-lang/ocaml ocamlopt; then
		eerror "In order to build ${PN} with native code support from ocaml"
		eerror "You first need to have a native code ocaml compiler."
		eerror "You need to install dev-lang/ocaml with ocamlopt useflag on."
		die "Please install ocaml with ocamlopt useflag"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-as-needed.patch"
}

src_compile() {
	local myconf

	if use threads; then
		myconf="$myconf THREADS=true"
	fi

	if use static; then
		myconf="$myconf STATIC=true"
	fi

	if use debug; then
		myconf="$myconf DEBUGGING=true"
	fi

	if use gtk; then
		myconf="$myconf UISTYLE=gtk2"
	else
		myconf="$myconf UISTYLE=text"
	fi

	use ocamlopt || myconf="$myconf NATIVE=false"

	# Discard cflags as it will try to pass them to ocamlc...
	emake -j1 $myconf CFLAGS="" || die "error making unsion"
}

src_test() {
	emake selftest ||  die "selftest failed"
}

src_install () {
	# install manually, since it's just too much
	# work to force the Makefile to do the right thing.
	newbin unison unison-${SLOT} || die
	dodoc BUGS.txt CONTRIB INSTALL NEWS \
	      README ROADMAP.txt TODO.txt || die

	if use doc; then
		dohtml "${DISTDIR}/${P}-manual.html" || die
		dodoc "${DISTDIR}/${P}-manual.pdf" || die
	fi
	use ocamlopt || export STRIP_MASK="*/bin/*"
}

pkg_postinst() {
	elog "Unison now uses SLOTs, so you can specify servercmd=/usr/bin/unison-${SLOT}"
	elog "in your profile files to access exactly this version over ssh."
	elog "Or you can use 'eselect unison' to set the version."
}
