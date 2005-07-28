# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/mozilla-launcher.eclass,v 1.12 2005/07/28 21:06:03 agriffis Exp $

inherit nsplugins multilib

# update_mozilla_launcher_symlinks
# --------------------------------
# Create or remove the following symlinks in /usr/bin:
#
#    firefox -> firefox-bin
#    thunderbird -> thunderbird-bin
#    mozilla -> mozilla-bin
#    sunbird -> sunbird-bin
#
# The symlinks are removed if they're found to be dangling.  They are
# created according to the following rules:
#
# - If there's a -bin symlink in /usr/bin, and no corresponding
#   non-bin symlink, then create one.
#
# - Can't do this in src_install otherwise it overwrites the one
#   for the non-bin package.
#
# - Link to the -bin symlink so it's easier to detect when to
#   remove the symlink.
#
# NOTE: This eclass does *not* manage the launcher stubs in /usr/bin except
# when a -bin package is installed and the corresponding from-source
# package is not installed.  The usual stubs are actually installed in
# src_install so they are included in the package inventory.
#
update_mozilla_launcher_symlinks() {
	local f browsers="mozilla firefox thunderbird sunbird"
	cd ${ROOT}/usr/bin

	# Remove launcher symlinks that no longer apply

	for f in ${browsers}; do
		if [[ -L ${f} && ! -f ${f} ]]; then
			einfo "Removing dangling ${f} launcher"
			rm -f ${f}
		fi
	done

	# Create new symlinks

	for f in ${browsers}; do
		if [[ -e ${f}-bin && ! -e ${f} ]]; then
			einfo "Adding link from ${f}-bin to ${f}"
			ln -s ${f}-bin ${f}
		fi
	done
}

# install_mozilla_launcher_stub name libdir
# -----------------------------------------
# Install a stub called /usr/bin/$name that executes mozilla-launcher
#
# Note: $PLUGINS_DIR comes from nsplugins (specifically the deprecated section).
#
install_mozilla_launcher_stub() {
	[[ -n $2 ]] || die "install_launcher_stub requires two arguments"
	declare name=$1
	declare libdir=$2

	dodir /usr/bin
	cat <<EOF >${D}/usr/bin/${name}
#!/bin/sh
#
# Stub script to run mozilla-launcher.  We used to use a symlink here
# but OOo brokenness makes it necessary to use a stub instead:
# http://bugs.gentoo.org/show_bug.cgi?id=78890

export MOZILLA_LAUNCHER=${name}
export MOZILLA_LIBDIR=${libdir}
export MOZ_PLUGIN_PATH=\${MOZ_PLUGIN_PATH:-/usr/$(get_libdir)/$PLUGINS_DIR}
exec /usr/libexec/mozilla-launcher "\$@"
EOF
	chmod 0755 ${D}/usr/bin/${name}
}
