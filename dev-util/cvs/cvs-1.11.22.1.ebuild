# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cvs/cvs-1.11.22.1.ebuild,v 1.2 2008/06/16 18:11:58 robbat2 Exp $

DESCRIPTION="Concurrent Versions System - source code revision control tools"
HOMEPAGE="http://www.cvshome.org/"
SRC_URI="mirror://gnu/non-gnu/cvs/source/nightly-snapshots/stable/${P}.tar.bz2
	doc? ( mirror://gnu/non-gnu/cvs/source/nightly-snapshots/stable/cederqvist-${PV}.html.bz2
		mirror://gnu/non-gnu/cvs/source/nightly-snapshots/stable/cederqvist-${PV}.pdf
		mirror://gnu/non-gnu/cvs/source/nightly-snapshots/stable/cederqvist-${PV}.ps )"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="doc emacs"

DEPEND=">=sys-libs/zlib-1.1.4"

src_unpack() {
	unpack ${A}
	# remove a useless binary
	einfo "Removing a compiled binary"
	find "${S}" -type f -name getdate -exec rm \{} \;
}

src_compile() {
	econf --with-tmpdir=/tmp || die
	emake || die "emake failed"
}

src_install() {
	einstall || die

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/cvspserver.xinetd.d cvspserver || die "newins failed"

	dodoc BUGS ChangeLog* DEVEL* FAQ HACKING \
		MINOR* NEWS PROJECTS README* TESTS TODO

	if use emacs; then
		insinto /usr/share/emacs/site-lisp
		doins cvs-format.el || die "doins failed"
	fi

	if use doc; then
		dodoc "${DISTDIR}"/cederqvist-${PV}.pdf
		dodoc "${DISTDIR}"/cederqvist-${PV}.ps
		tar xjf "${DISTDIR}"/cederqvist-${PV}.html.tar.bz2
		dohtml -r cederqvist-${PV}.html/*
		cd "${D}"/usr/share/doc/${PF}/html/
		ln -s cvs.html index.html
	fi
}

src_test() {
	einfo "FEATURES=\"maketest\" has been disabled for dev-util/cvs"
}
