# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/omake/omake-0.9.8.5.ebuild,v 1.3 2008/01/18 08:21:55 aballier Exp $

inherit eutils toolchain-funcs multilib

EAPI="1"

RESTRICT="installsources"
EXTRAPV="-3"
DESCRIPTION="Make replacement"
HOMEPAGE="http://omake.metaprl.org/"
SRC_URI="http://omake.metaprl.org/downloads/${P}${EXTRAPV}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc fam ncurses +ocamlopt readline"
DEPEND=">=dev-lang/ocaml-3.0.8
	ncurses? ( >=sys-libs/ncurses-5.3 )
	fam? ( virtual/fam )
	readline? ( >=sys-libs/readline-4.3 )"

pkg_setup() {
	if use ocamlopt && ! built_with_use --missing true dev-lang/ocaml ocamlopt; then
		eerror "In order to build ${PN} with native code support from ocaml"
		eerror "You first need to have a native code ocaml compiler."
		eerror "You need to install dev-lang/ocaml with ocamlopt useflag on."
		die "Please install ocaml with ocamlopt useflag"
	fi
}

use_boolean() {
	if use $1; then
		echo "true"
	else
		echo "false"
	fi
}

src_compile() {
	# Configuration steps...
	echo "PREFIX = \$(dir \$\"/usr\")" > .config
	echo "BINDIR = \$(dir \$\"\$(PREFIX)/bin\")" >> .config
	echo "LIBDIR = \$(dir \$\"\$(PREFIX)/$(get_libdir)\")" >> .config
	echo "MANDIR = \$(dir \$\"\$(PREFIX)/man\")" >> .config

	echo "CC = $(tc-getCC)" >> .config
	echo "CFLAGS = ${CFLAGS}" >> .config

	if use ocamlopt; then
		echo "NATIVE_ENABLED = true" >> .config
		echo "BYTE_ENABLED = false" >> .config
	else
		echo "NATIVE_ENABLED = false" >> .config
		echo "BYTE_ENABLED = true" >> .config
	fi

	echo "NATIVE_PROFILE = false" >> .config

	echo "READLINE_ENABLED = $(use_boolean readline)" >> .config
	echo "FAM_ENABLED = $(use_boolean fam)" >> .config
	echo "NCURSES_ENABLED = $(use_boolean ncurses)" >> .config

	echo "DEFAULT_SAVE_INTERVAL = 60" >> .config

	echo "OCAMLDEP_MODULES_ENABLED = false" >> .config

	emake all || die "compilation failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc CHANGELOG.txt
	if use doc; then
		dodoc doc/ps/omake-doc.{pdf,ps} doc/txt/omake-doc.txt
		dohtml -r doc/html/*
	fi
	use ocamlopt || export STRIP_MASK="*/bin/*"
}
