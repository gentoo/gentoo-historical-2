# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gaim-slashexec/gaim-slashexec-1.1_beta1.ebuild,v 1.1 2005/12/20 20:06:39 gothgirl Exp $

inherit debug

DESCRIPTION="execute commands from within a Gaim conversation"
HOMEPAGE="http://guifications.sourceforge.net/SlashExec/"
SRC_URI="mirror://sourceforge/guifications/slashexec-1.1beta.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

DEPEND="net-im/gaim"

S="${WORKDIR}/slashexec-1.1beta"

src_compile() {
	local myconf
	use debug && myconf="${myconf} --enable-debug"

	econf ${myconf} || die "Configuration failed"

	emake -j1 || die "Make failed"
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README VERSION
}

