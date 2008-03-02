# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/dvdisaster/dvdisaster-0.70.4.ebuild,v 1.4 2008/03/02 19:34:46 maekke Exp $

inherit eutils gnome2

DESCRIPTION="Data-protection and recovery tool for DVDs"
HOMEPAGE="http://dvdisaster.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
SLOT="0"
IUSE_LINGUAS="linguas_cs linguas_de linguas_it linguas_sv"
IUSE="${IUSE_LINGUAS} gnome nls"

DEPEND=">=x11-libs/gtk+-2.2
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"
RDEPEND=">=x11-libs/gtk+-2.2
	nls? ( virtual/libintl )"

S=${WORKDIR}/${P/.1/}

src_compile() {
	local myconf
	# use_with won't work
	if use nls ; then
		myconf="${myconf} --with-nls=yes --localedir=/usr/share/locale"
	else
		myconf="${myconf} --with-nls=no"
	fi
	use debug && myconf="${myconf} --debug --with-memdebug=yes"
	econf ${myconf} \
		--docdir=/usr/share/doc \
		--docsubdir=${PF} \
		|| die "econf failed"
	make || die "make failed"
}

src_install() {
	local docdir="${D}/usr/share/doc/${PF}"
	local mandir="${D}/usr/share/man"
	local localedir="${D}/usr/share/locale"

	make install \
	BINDIR=${D}/usr/bin \
	DOCSUBDIR=${docdir} \
	MANDIR=${mandir} \
	LOCALEDIR=${localedir} \
	|| die "make install failed"

	insinto /usr/share/pixmaps
	newins contrib/${PN}48.png ${PN}.png
	for res in 16 32 48 64 ; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps/
		newins contrib/${PN}${res}.png ${PN}.png
	done

	sed -i -e "s:48::" "${S}"/contrib/${PN}.desktop || die "sed failed"
	insinto /usr/share/applications
	doins contrib/${PN}.desktop

	# no sane way to disable unwanted LINGUAS at compile time
	# there are no Italian docs, only manpage and localization for now
	for lang in cs de it sv ; do
		use linguas_${lang} || rm -rf ${docdir}/${lang} ${mandir}/${lang} ${localedir}/${lang}
		use linguas_${lang} || rm -f ${docdir}/CREDITS.${lang}
	done
	rm -f "${D}"/usr/bin/*.sh
}

pkg_postinst() {
	use gnome && gnome2_pkg_postinst
}

pkg_postrm() {
	use gnome && gnome2_pkg_postrm
}
