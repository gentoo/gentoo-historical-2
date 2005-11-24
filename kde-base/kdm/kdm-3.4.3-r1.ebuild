# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdm/kdm-3.4.3-r1.ebuild,v 1.3 2005/11/24 19:52:01 corsair Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE login manager, similar to xdm and gdm"
KEYWORDS="~alpha ~amd64 ~ppc ppc64 sparc ~x86"
IUSE="pam"

KMEXTRA="kdmlib/"
KMEXTRACTONLY="libkonq/konq_defaults.h
	    kioslave/thumbnail/configure.in.in" # for the HAVE_LIBART test
KMCOMPILEONLY="kcontrol/background"
DEPEND="pam? ( kde-base/kdebase-pam )
	$(deprange $PV $MAXKDEVER kde-base/kcontrol)"
	# Requires the desktop background settings and kdm modules,
	# so until we separate the kcontrol modules into separate ebuilds :-),
	# there's a dep here

# Fix XDMCP (kde bug 114385). Applied for 3.4.4.
PATCHES="${FILESDIR}/kdebase-3.4.3-xdmcp.patch"

# Avoid using imake (kde bug 114466).
PATCHES="${PATCHES} ${FILESDIR}/kdebase-3.4.3-noimake.patch"

src_compile() {
	local myconf="--with-x-binaries-dir=/usr/bin"

	if use pam; then
		myconf="${myconf} --with-pam=yes"
	else
		myconf="${myconf} --with-pam=no --with-shadow"
	fi

	kde-meta_src_compile myconf configure
	kde_remove_flag kdm/kfrontend -fomit-frame-pointer
	kde-meta_src_compile make
}

src_install() {
	kde-meta_src_install
	cd ${S}/kdm && make DESTDIR=${D} GENKDMCONF_FLAGS="--no-old --no-backup --no-in-notice" install

	# We tell kdm to /use session files from /usr/share/xsessions.
	# I've removed some other kdmrc mods from here, since it's not clear why
	# the default aren't ok (and I'm not sure about the benefits of using
	# the xdm configfiles under /etc/X11 instead of our own ones),
	# and it's the Gentoo Way to avoid modifying upstream behaviour.
	# Tell me if you don't like this. --danarmak
	cd ${D}/${KDEDIR}/share/config/kdm || die
	sed -i -e "s:#SessionsDirs=:SessionsDirs=/usr/share/xsessions\n#SessionsDirs=:" \
		-e "s:#GreetFont=:GreetFont=Sans Serif,24,-1,5,50,0,0,0,0,0\n#GreetFont=:" \
		-e "s:#StdFont=:StdFont=Sans Serif,12,-1,5,50,0,0,0,0,0\n#StdFont=:" \
		-e "s:#FailFont=:FailFont=Sans Serif,12,-1,5,75,0,0,0,0,0\n#FailFont=:" \
		-e "s:#AntiAliasing=:AntiAliasing=true\n#AntiAliasing=:" \
		kdmrc
}

pkg_postinst() {
	# set the default kdm face icon if it's not already set by the system admin
	# because this is user-overrideable in that way, it's not in src_install
	if [ ! -e "${ROOT}${KDEDIR}/share/apps/kdm/faces/.default.face.icon" ];	then
		mkdir -p "${ROOT}${KDEDIR}/share/apps/kdm/faces"
		cp "${ROOT}${KDEDIR}/share/apps/kdm/pics/users/default1.png" \
		    "${ROOT}${KDEDIR}/share/apps/kdm/faces/.default.face.icon"
	fi
}
