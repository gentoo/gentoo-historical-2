# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/chicken/chicken-3.1.0.ebuild,v 1.4 2008/04/15 15:26:08 armin76 Exp $

inherit multilib elisp-common

DESCRIPTION="Chicken is a Scheme interpreter and native Scheme to C compiler"
SRC_URI="http://chicken.wiki.br/releases/${PV}/${P}.tar.gz"
HOMEPAGE="http://www.call-with-current-continuation.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~ppc ppc64 x86"
IUSE="emacs"

DEPEND=">=dev-libs/libpcre-7.6
		sys-apps/texinfo
		emacs? ( virtual/emacs )"

SITEFILE=50hen-gentoo.el

src_unpack() {
	unpack ${A}; cd "${S}"
	sed "s:/lib:/$(get_libdir):g" -i defaults.make
}

src_compile() {
	# $A is used by the makefile so >_>
	unset A

	OPTIONS="PLATFORM=linux PREFIX=/usr USE_HOST_PCRE=1"
	echo $OPTIONS
	emake ${OPTIONS} C_COMPILER_OPTIMIZATION_OPTIONS="${CFLAGS}" || die

	use emacs && elisp-comp hen.el
}

# chicken doesn't seem to honor CHICKEN_PREFIX CHICKEN_HOME or LD_LIBRARY_PATH=${S}/.libs/
RESTRICT=test
#src_test() {
#	cd tests
#	bash runtests.sh
#}

src_install() {
	unset A

	emake ${OPTIONS} DESTDIR="${D}" install || die
	dodoc ChangeLog* NEWS
	dohtml -r html/
	rm -rf "${D}"/usr/share/chicken/doc

	# put a .keep in the default egg repository
#	touch .keep
#	insinto /usr/$(get_libdir)/chicken/3
#	doins .keep

	keepdir /usr/$(get_libdir)/chicken/3

	if use emacs; then
		elisp-install ${PN} *.{el,elc}
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
