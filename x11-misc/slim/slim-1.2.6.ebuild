# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/slim/slim-1.2.6.ebuild,v 1.4 2007/07/12 13:48:25 gustavoz Exp $

inherit toolchain-funcs

DESCRIPTION="Simple Login Manager"
HOMEPAGE="http://slim.berlios.de"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 sparc ~x86"
IUSE=""

DEPEND="x11-proto/xproto
	x11-libs/libXmu
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXft
	media-libs/libpng
	media-libs/jpeg"
RDEPEND="${DEPEND}
	media-fonts/corefonts"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# respect C[XX]FLAGS, fix crosscompile,
	# fix linking order for --as-needed"
	sed -i -e "s:^CXX=.*:CXX=$(tc-getCXX) ${CXXFLAGS}:" \
		-e "s:^CC=.*:CC=$(tc-getCC) ${CFLAGS}:" \
		-e "s:^MANDIR=.*:MANDIR=/usr/share/man:" \
		-e "s:/usr/X11R6:/usr:" \
		-e "s:^\t\(.*\)\ \$(LDFLAGS)\ \(.*\):\t\1\ \2\ \$(LDFLAGS):g" \
		Makefile || die 'sed failed in Makefile'

	# Remove all X11R6 references from slim.conf
	# Set slim to daemon mode as default to stop xdm runscript from throwing errors on stop
	# Set the default logfile to /dev/null to avoid cluttering up the harddisk
	# as slim puts a lot of garbage in its logfile
	sed -i -e 's#X11R6/##g' -e 's#/usr/bin:##' \
		-e 's/# daemon/daemon/' \
		-e 's#/var/log/slim.log#/dev/null#g' \
		slim.conf || die "sed failed in slim.conf"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc xinitrc.sample README TODO THEMES
}

pkg_postinst() {
	elog
	elog "The configuration file is located at /etc/slim.conf."
	elog "If you wish ${PN} to start automatically, set DISPLAYMANAGER=\"${PN}\" "
	elog "in /etc/conf.d/xdm and run \"rc-update add xdm default\"."
	elog
	elog "${PN} uses .xinitrc in the user's home directory and /etc/slim.conf"
	elog "for session management. For further information, see README and"
	elog "xinitrc.sample in /usr/share/doc/${PF}."
	elog
}
