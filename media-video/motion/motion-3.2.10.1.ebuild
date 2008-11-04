# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/motion/motion-3.2.10.1.ebuild,v 1.3 2008/11/04 14:43:56 loki_val Exp $

inherit eutils autotools

DESCRIPTION="Motion is a video motion detector with tracking-support for webcams."
HOMEPAGE="http://www.lavrsen.dk/twiki/bin/view/Motion/WebHome"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~x86"
IUSE="ffmpeg mysql postgres v4l"

DEPEND="sys-libs/zlib
	media-libs/jpeg
	media-video/mjpegtools
	ffmpeg? ( <media-video/ffmpeg-0.4.9_p20081014 )
	mysql? ( virtual/mysql )
	postgres? ( virtual/postgresql-server )"

pkg_setup() {
	enewuser motion -1 -1 -1 "video" || die "failed to create motion user"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-asneeded.patch"
	epatch "${FILESDIR}/${P}-ffmpegheaders.patch"
	eautoreconf
}

src_compile() {
	econf --without-optimizecpu \
		$(use_with v4l) \
		$(use_with mysql) \
		$(use_with postgres pgsql) \
		$(use_with ffmpeg)

	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."

	# Install init script.
	newinitd "${FILESDIR}"/motion.init-r1 motion
	newconfd "${FILESDIR}"/motion.confd motion

	# Create correct dir for motion.pid
	dodir /var/run/motion
	fowners motion:video /var/run/motion
	fperms 750 /var/run/motion
	keepdir /var/run/motion

	# Rename configuration file.
	mv "${D}"/etc/motion-dist.conf "${D}"/etc/motion.conf

	# Remove dummy documentation and install it using ebuild functions.
	rm -rf "${D}"/usr/share/doc/${P}
	dodoc CHANGELOG CODE_STANDARD CREDITS FAQ README README.FreeBSD *.conf
	dohtml *.html
}

pkg_postinst() {
	elog "You need to setup /etc/motion.conf before running"
	elog "motion for the first time. You can install motion"
	elog "detection as a service, use:"
	elog "rc-update add motion default"
}
