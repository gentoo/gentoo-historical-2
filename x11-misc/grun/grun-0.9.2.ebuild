# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/grun/grun-0.9.2.ebuild,v 1.22 2005/03/05 13:52:01 luckyduck Exp $

inherit eutils

IUSE="nls"

DESCRIPTION="A GTK/X11 application launcher with nice features such as a history"

# Unfortunately the original homepage is not available anymore. The
# tarball and the patch (identiacal with grun_0.9.2-9.diff just
# renamed to grun-0.9.2-gentoo.diff) have been taken from
# http://packages.debian.org/unstable/x11/grun.html.

RESTRICT="nomirror"
SRC_URI="mirror://debian/pool/main/g/grun/grun_0.9.2.orig.tar.gz"
# Not valid anymore, see
# http://packages.debian.org/unstable/x11/grun.html instead
HOMEPAGE="http://www.geocities.com/ResearchTriangle/Facility/1468/sg/grun.html"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ppc ~amd64"

# The dependencies following the gentoo policy as suggested by gbevin
DEPEND="=dev-libs/glib-1.2*
	=x11-libs/gtk+-1.2*
	nls? ( sys-devel/gettext )
	sys-devel/gnuconfig
	sys-devel/automake"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${PF}-gentoo.diff.bz2
}

src_compile() {
	local myconf

	use nls && myconf="--enable-nls" || myconf="--disable-nls"

	if [ -z ${TERM} ] ; then
		TERM=xterm
	fi

	ebegin "Running automake"
		automake --add-missing &>/dev/null
	eend $?

	econf \
		--enable-testfile \
		--with-default-xterm=${TERM} \
		--enable-associations \
		${myconf} || die
	emake || die
}

src_install() {
	einstall || die

	dodoc ABOUT-NLS AUTHORS BUGS COPYING ChangeLog INSTALL \
		LANGUAGES NEWS README TODO
}

pkg_postinst() {
	einfo "It is recommended to bind grun to a keychain. Fluxbox users can"
	einfo "do this by appending e.g. the following line to ~/.fluxbox/keys:"
	einfo ""
	einfo "Mod4 r :ExecCommand grun"
	einfo ""
	einfo "Then reconfigure Fluxbox (using the menu) and hit <WinKey>-<r>"
	einfo ""
	einfo "The default system-wide definition file for associating file"
	einfo "extensions with applications is /usr/share/grun/gassoc, the"
	einfo "default system-wide definition file for recognized console"
	einfo "applications is /usr/share/grun/consfile. They can be overridden"
	einfo "on a per user basis by ~/.gassoc and ~/.consfile respectively."
	einfo ""
	einfo "To change the default terminal application grun uses, adjust the"
	einfo "TERM environment variable accordingly and remerge grun, e.g."
	einfo ""
	einfo "export TERM=Eterm && emerge grun"
}
