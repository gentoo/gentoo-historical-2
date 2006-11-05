# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/motion/motion-3.2.7.ebuild,v 1.2 2006/11/05 10:26:55 vapier Exp $

inherit eutils

DESCRIPTION="Motion is a video motion detector with tracking-support for webcams."
HOMEPAGE="http://www.lavrsen.dk/twiki/bin/view/Motion/WebHome"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE="ffmpeg  mysql postgres v4l"

DEPEND="sys-libs/zlib
	media-libs/jpeg
	ffmpeg? ( media-video/ffmpeg )
	mysql? ( dev-db/mysql )
	postgres? ( dev-db/postgresql )"

src_compile() {
	econf \
		$(use_with v4l) \
		$(use_with mysql) \
		$(use_with postgres pgsql) \
		$(use_with ffmpeg) \
		|| die "econfigure failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"

	# install init-script
	newinitd ${FILESDIR}/motion.init motion || die

	# copy configuration file
	cp ${D}/etc/motion-dist.conf ${D}/etc/motion.conf

	# cleanup unused files 
	cd ${D}/usr/share/doc/${P}/examples/
	rm motion.init-Debian motion.init-RH motion.init-FreeBSD.sh
}

pkg_postinst() {
	ewarn "You need to setup /etc/motion.conf before running"
	ewarn "motion for the first time."
	einfo "Examples are available at /usr/share/doc/${P}/examples"
	einfo
	einfo "You can install motion detection as a service, use:"
	einfo "rc-update add motion default"
}
