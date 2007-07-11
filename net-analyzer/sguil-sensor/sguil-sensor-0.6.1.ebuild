# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/sguil-sensor/sguil-sensor-0.6.1.ebuild,v 1.3 2007/07/11 23:49:24 mr_bones_ Exp $

inherit eutils

MY_PV="${PV/_p/p}"
DESCRIPTION="Sensor part of sguil Network Security Monitoring"
HOMEPAGE="http://sguil.sourceforge.net"
SRC_URI="mirror://sourceforge/sguil/sguil-sensor-${MY_PV}.tar.gz"

LICENSE="QPL"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/tcl-8.3"
RDEPEND="${DEPEND}
	>=dev-tcltk/tclx-8.3
	>=net-analyzer/snort-2.4.1-r1
	>=net-analyzer/barnyard-0.2.0-r1
	net-analyzer/sancp
	dev-ml/pcre-ocaml"

S="${WORKDIR}/sguil-${MY_PV}"

pkg_setup() {
	if built_with_use dev-lang/tcl threads ; then
		eerror
		eerror "Sguil does not run when tcl was built with threading enabled."
		eerror "Please rebuild tcl without threads and reemerge this ebuild."
		eerror
		die
	fi

	if ! built_with_use net-analyzer/snort sguil ; then
		eerror
		eerror "You need to emerge snort with 'sguil' USE flag to get"
		eerror "the full sguil functionality"
		eerror
		die
	fi
	enewgroup sguil
	enewuser sguil -1 -1 /var/lib/sguil sguil
}

src_unpack() {
	unpack ${A}
	cd ${S}/sensor
	sed -i -e 's:192.168.8.1:127.0.0.1:' -e "s:gateway:${HOSTNAME}:" \
		-e 's:/snort_data:/var/lib/sguil:' -e 's:DAEMON 0:DAEMON 1:' \
		-e 's:DEBUG 1:DEBUG 0:g' sensor_agent.conf || die "sed failed"
	sed -i -e 's:/var/run/sensor_agent.pid:/var/run/sguil/sensor.pid:' \
		sensor_agent.tcl || die "sed failed"
}

src_install() {

	dodoc doc/*

	dobin sensor/sensor_agent.tcl

	newinitd "${FILESDIR}/log_packets.initd" log_packets
	newinitd "${FILESDIR}/sensor_agent.initd" sensor_agent
	newconfd "${FILESDIR}/log_packets.confd" log_packets
	insinto /etc/sguil
	doins sensor/sensor_agent.conf

	# Create the directory structure
	diropts -g sguil -o sguil
	keepdir /var/lib/sguil /var/run/sguil /var/lib/sguil/archive \
		"/var/lib/sguil/${HOSTNAME}" \
		"/var/lib/sguil/${HOSTNAME}/portscans" \
		"/var/lib/sguil/${HOSTNAME}/ssn_logs" \
		"/var/lib/sguil/${HOSTNAME}/dailylogs" \
		"/var/lib/sguil/${HOSTNAME}/sancp"

}

pkg_postinst() {
	elog
	elog "You should check /etc/sguil/sensor_agent.conf and"
	elog "/etc/init.d/logpackets and ensure that they are accurate"
	elog "for your environment. They should work providing that you"
	elog "are running the sensor on the same machine as the server."
	elog "This ebuild assumes that you are running a single sensor"
	elog "environment, if this is not the case then you must make sure"
	elog "to modify /etc/sguil/sensor_agent.conf and change the HOSTNAME variable."
	elog "You should crontab the /etc/init.d/log_packets script to restart"
	elog "each hour."
	elog
}
