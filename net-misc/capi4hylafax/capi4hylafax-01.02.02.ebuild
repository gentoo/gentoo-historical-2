# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/capi4hylafax/capi4hylafax-01.02.02.ebuild,v 1.2 2003/12/09 17:57:21 lanius Exp $

DESCRIPTION="CAPI4HylaFAX - send/recieve faxes via CAPI and AVM Fritz!Cards."
SRC_URI="ftp://ftp.avm.de/tools/capi4hylafax.linux/capi4hylafax-01.02.02.tar.gz"
HOMEPAGE="http://capi4linux.thepenguin.de/"

IUSE=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="virtual/glibc
	>=media-libs/tiff-3.5.5
	net-dialup/capi4k-utils
	sys-devel/automake"

RDEPEND="virtual/glibc
	>=media-libs/tiff-3.5.5
	net-dialup/capi4k-utils
	net-mail/metamail
	virtual/ghostscript
	hylafax? ( net-misc/hylafax )"

src_compile() {
	./configure --prefix=/usr --with-hylafax-spooldir=/var/spool/fax || die
	emake || die
}

src_install() {
	make install DESTDIR=${D} || die
	insinto /var/spool/fax/etc
	doins config.faxCAPI
	dodoc README.html
	dodoc LIESMICH.html
	dodoc sample_*
	dodoc fritz_pic.tif
	dodoc GenerateFileMail.pl
	exeinto /etc/init.d
	doexe ${FILESDIR}/capi4hylafax
}

pkg_postinst() {
	einfo "To use CAPI4HylaFAX:"
	einfo "Make sure the your isdn/capi devices are owned by"
	einfo "the "fax" user (set in /etc/devfsd.conf)."
	einfo "Modify /var/spool/fax/etc/config.faxCAPI"
	einfo "to suit your system, and append the line"
	einfo "SendFaxCmd:             /usr/bin/c2faxsend"
	einfo "to your HylaFAX config file (/var/spool/fax/etc/config)."
}
