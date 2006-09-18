# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/gnusim8085/gnusim8085-1.2.90.ebuild,v 1.1 2006/09/18 22:12:33 calchan Exp $

inherit eutils

MY_PN="GNUSim8085"

DESCRIPTION="A GTK2 8085 Simulator"
HOMEPAGE="http://sourceforge.net/projects/gnusim8085"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls"

DEPEND=">=x11-libs/gtk+-2.0
	>=gnome-base/libgnomeui-2.0
	nls? ( >=sys-devel/gettext-0.10.40 )"

S=${WORKDIR}/${MY_PN}-${PV}

src_unpack() {
	unpack ${A}

	# We'll install data the Gentoo way
	sed -i \
		-e "s:install-exec-am install-data-am:install-exec-am:" \
		-e "s:SUBDIRS = intl po macros src pixmaps doc:SUBDIRS = intl po macros src:" \
		${S}/Makefile.in \
		|| die "Patch failed"
}

src_compile() {
	econf $(use_enable nls) || die "Configuration failed"
	emake gnusim8085_LDADD='$(GNOME_LIBS)' || die "Compilation failed"
}

src_install() {
	einstall || die "Installation Failed!"

	cd ${S}
	dodoc README doc/asm_reference.txt AUTHORS ChangeLog NEWS TODO
	newman doc/gnusim8085.1 gnusim8085

	insinto /usr/share/doc/${PF}/examples
	doins doc/examples/*.asm

	newicon pixmaps/gnusim8085_icon.png gnusim8085.png
	make_desktop_entry gnusim8085 GNUSim8085 gnusim8085.png Development
}
