# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/surfraw/surfraw-2.1.1.ebuild,v 1.1 2005/10/19 18:31:39 seemant Exp $

inherit bash-completion eutils

DESCRIPTION="A fast unix command line interface to WWW"
HOMEPAGE="http://alioth.debian.org/projects/surfraw/"
SRC_URI="mirror://debian/pool/main/s/surfraw/${PN}_${PV}.tar.gz"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

src_unpack() {
	unpack ${A}; cd ${S}

	sed -i 's,/lib/,/share/,g' surfraw-bash-completion surfraw.1.in elvi.1sr.in
	epatch ${FILESDIR}/${PN}-gentoo_pkg_tools.patch
}

src_compile() {
	econf \
		--with-elvidir='$(datadir)'/surfraw || die "./configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc debian/changelog AUTHORS HACKING NEWS README TODO

	dobashcompletion surfraw-bash-completion
}

pkg_postinst() {
	bash-completion_pkg_postinst
	einfo
	einfo "You can get a list of installed elvi by just typing 'surfraw' or"
	einfo "the abbreviated 'sr'."
	einfo
	einfo "You can try some searches, for example:"
	einfo "$ sr ask why is jeeves gay? "
	einfo "$ sr google -results=100 RMS, GNU, which is sinner, which is sin?"
	einfo "$ sr rhyme -method=perfect Julian"
	einfo
	einfo "The system configuration file is /etc/surfraw.conf"
	einfo
	einfo "Users can specify preferences in '~/.surfraw.conf'  e.g."
	einfo "SURFRAW_graphical_browser=mozilla"
	einfo "SURFRAW_text_browser=w3m"
	einfo "SURFRAW_graphical=no"
	einfo
	einfo "surfraw works with any graphical and/or text WWW browser"
	einfo
	if has_version '=www-client/surfraw-1.0.7'; then
		ewarn "surfraw usage has changed slightly since version 1.0.7, elvi are now called"
		ewarn "using the 'sr' wrapper script as described above.  If you wish to return to"
		ewarn "the old behaviour you can add /usr/share/surfraw to your \$PATH"
	fi
}
