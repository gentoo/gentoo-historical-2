# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/hevea/hevea-1.10-r1.ebuild,v 1.2 2010/12/29 14:57:57 tomka Exp $

EAPI="2"

inherit eutils multilib

IUSE="+ocamlopt"

DESCRIPTION="HeVeA is a quite complete and fast LaTeX to HTML translator"
HOMEPAGE="http://pauillac.inria.fr/~maranget/hevea/"
SRC_URI="ftp://ftp.inria.fr/INRIA/moscova/hevea/${P}.tar.gz"

LICENSE="QPL"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc x86"

DEPEND=">=dev-lang/ocaml-3.10.2[ocamlopt?]"
RDEPEND="${DEPEND}"

src_compile() {
	rm -f config.sh
	emake PREFIX=/usr DESTDIR="${D}" LIBDIR="/usr/$(get_libdir)/hevea" LATEXLIBDIR="/usr/share/texmf-site/tex/latex/hevea" config.sh || die "Failed to create config.sh"
	if use ocamlopt; then
		emake PREFIX=/usr || die "Failed to build native code binaries"
	else
		emake PREFIX=/usr TARGET=byte || die "Failed to build bytecode binaries"
	fi
}

src_install() {
	if use ocamlopt; then
		emake DESTDIR="${D}" PREFIX=/usr install || die "Install failed"
	else
		emake DESTDIR="${D}" PREFIX=/usr TARGET=byte install || die "Install failed"
	fi

	dodoc README CHANGES
}

# If texmf-update is present this means we have a latex install; update it so
# that hevea.sty can be found
# Do not (r)depend on latex though because hevea does not need it itself
# If latex is installed later, it will see hevea.sty

pkg_postinst() {
	if [ "$ROOT" = "/" ] && [ -x /usr/sbin/texmf-update ] ; then
		/usr/sbin/texmf-update
	fi
}

pkg_postrm() {
	if [ "$ROOT" = "/" ] && [ -x /usr/sbin/texmf-update ] ; then
		/usr/sbin/texmf-update
	fi
}
