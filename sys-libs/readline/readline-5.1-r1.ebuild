# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/readline/readline-5.1-r1.ebuild,v 1.1 2005/12/20 01:26:22 vapier Exp $

inherit eutils multilib

# Official patches
PLEVEL=""

DESCRIPTION="Another cute console display library"
HOMEPAGE="http://cnswww.cns.cwru.edu/php/chet/readline/rltop.html"
SRC_URI="mirror://gnu/readline/${P}.tar.gz
	${PLEVEL//x/mirror://gnu/${PN}/${PN}-${PV}-patches/${PN}${PV/\.}-}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc-macos ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

# We must be certain that we have a bash that is linked
# to its internal readline, else we may get problems.
RDEPEND=">=sys-libs/ncurses-5.2-r2"
DEPEND="${RDEPEND}
	>=app-shells/bash-2.05b-r2"

src_unpack() {
	unpack ${P}.tar.gz

	cd "${S}"
	for x in ${PLEVEL//x} ; do
		epatch "${DISTDIR}"/${PN}${PV/\.}-${x}
	done
	epatch "${FILESDIR}"/bash-3.0-etc-inputrc.patch
	epatch "${FILESDIR}"/${PN}-5.0-no_rpath.patch
	epatch "${FILESDIR}"/${P}-cleanups.patch
	epatch "${FILESDIR}"/${P}-callback-segv.patch #115326

	# force ncurses linking #71420
	sed -i -e 's:^SHLIB_LIBS=:SHLIB_LIBS=-lncurses:' support/shobj-conf || die "sed"
}

src_compile() {
	# the --libdir= is needed because if lib64 is a directory, it will default
	# to using that... even if CONF_LIBDIR isnt set or we're using a version
	# of portage without CONF_LIBDIR support.
	econf --with-curses --libdir=/usr/$(get_libdir) || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodir /$(get_libdir)

	if ! use userland_Darwin ; then
		mv "${D}"/usr/$(get_libdir)/*.so* "${D}"/$(get_libdir)
		chmod a+rx "${D}"/$(get_libdir)/*.so*

		# Bug #4411
		gen_usr_ldscript libreadline.so
		gen_usr_ldscript libhistory.so
	fi

	dodoc CHANGELOG CHANGES README USAGE NEWS
	docinto ps
	dodoc doc/*.ps
	dohtml -r doc
}

pkg_preinst() {
	# Backwards compatibility #29865
	if [[ -e ${ROOT}/$(get_libdir)/libreadline.so.4 ]] ; then
		cp -pPR "${ROOT}"/$(get_libdir)/libreadline.so.4* "${D}"/$(get_libdir)/
		touch "${D}"/$(get_libdir)/libreadline.so.4*
	fi
}

pkg_postinst() {
	if [[ -e ${ROOT}/$(get_libdir)/libreadline.so.4 ]] ; then
		ewarn "Your old readline libraries have been copied over."
		ewarn "You should run 'revdep-rebuild --soname libreadline.so.4' asap."
		ewarn "Once you have, you can safely delete /$(get_libdir)/libreadline.so.4*"
	fi
}
